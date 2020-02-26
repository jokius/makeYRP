<template>
  <div class="pan-zoom-body" @contextmenu="handler">
    <div v-if="!loaded" class="loaded">
      <body-loader />
    </div>
    <pan-zoom
      class="pan-zoom"
      :options="{
        minZoom: 0.4,
        maxZoom: 2,
        beforeMouseDown: checkMove,
        smoothScroll: false,
        zoomDoubleClickSpeed: 1
      }"
    >
      <drop class="drop" @drop="handleDrop">
        <right-click-menu :position="position" :current-obj="item" :replaced-items="menuItems">
          <canvas ref="renderCanvas" />
        </right-click-menu>
      </drop>
    </pan-zoom>
  </div>
</template>

<script>
  import { Application, Container, Loader, TilingSprite, Graphics } from 'pixi.js'
  import { mapState } from 'vuex'

  import RightClickMenu from './RightClickMenu'

  import { mousePosition } from '../../../../lib/mousePosition'
  import { loadTokens } from '../../api'
  import { rgbToXhex } from '../../../../lib/rgbToXhex'
  import { UPDATE_CURRENT_RIGHT_CLICK_MENU } from '../../stores/mutation-types'
  import { Token } from '../../../../lib/pixi/Token'
  import BodyLoader from '../../../ui/components/Loader'

  export default {
    name: 'Board',
    components: { BodyLoader, RightClickMenu },
    data() {
      return {
        app: {},
        playersContainer: {},
        gmContainer: {},
        mapContainer: {},
        gridContainer: {},
        tokens: {},
        position: { x: 0, y: 0 },
        menuItems: [],
        item: {},
        loaded: false,
      }
    },

    channels: {
      PageChannel: {
        received(obj) {
          if (obj.delete) {
            const sprite = this.playersContainer.getChildByName(`token_${obj.token.id}`)
            this.playersContainer.removeChild(sprite)
          } else if (obj.update) {
            this.tokens.changeToken(obj.token)
          } else {
            this.tokens.addToken(obj.token)
          }
        },
      },
    },

    computed: {
      ...mapState({
        currentPage: state => state.game.currentPage,
        sheets: state => state.game.sheets,
      }),

      params: {
        get() {
          return this.currentPage.params
        },
      },

      width: {
        get() {
          return parseInt(this.params.width, 10)
        },
      },

      height: {
        get() {
          return parseInt(this.params.height, 10)
        },
      },

      gridWidth: {
        get() {
          return parseInt(this.params.grid.width, 10)
        },
      },

      gridHeight: {
        get() {
          return parseInt(this.params.grid.height, 10)
        },
      },

      windowWidth: {
        get() {
          return window.screen.width * window.devicePixelRatio
        },
      },

      windowHeight: {
        get() {
          return window.screen.height * window.devicePixelRatio
        },
      },

      stage: {
        get() {
          return this.app.stage
        },
      },

      grid: {
        get() {
          return this.params.grid
        },
      },
    },

    watch: {
      params() {
        this.changeBackground()
        this.drawGrid()
      },
    },

    mounted() {
      const pageId = this.currentPage.id
      this.$cable.subscribe({ channel: 'PageChannel', page_id: pageId })
      this.loadBoard(pageId)
    },

    methods: {
      loadBoard(pageId) {
        this.createApp()
        this.initContainers()
        this.changeBackground()
        this.showContainers()
        this.drawGrid()
        this.tokens = new Token(this.sheets, this.grid, this.tokenRightMenu, this.playersContainer,
                                this.showContainers, this.moveToken)

        loadTokens(pageId).then(tokens => {
          tokens.forEach(token => this.tokens.addToken(token))
          this.loaded = true
        })
      },

      handleDrop({ sheet }, e) {
        const position = mousePosition(e)
        this.sendToken({ sheet_id: sheet.id, position_x: position.x, position_y: position.y - this.gridWidth })
      },

      sendToken(params) {
        this.$cable.perform({
          channel: 'PageChannel',
          action: 'add_token',
          data: { ...params },
        })
      },

      moveToken(params) {
        this.$cable.perform({
          channel: 'PageChannel',
          action: 'move_token',
          data: { ...params },
        })
      },

      removeToken(id) {
        this.$cable.perform({
          channel: 'PageChannel',
          action: 'remove_token',
          data: { id },
        })
      },

      tokenRightMenu(id) {
        this.menuItems = [{ title: 'Удалить токен', callback: () => this.removeToken(id) }]
        this.item = { type: 'token', id }
        this.$store.commit(UPDATE_CURRENT_RIGHT_CLICK_MENU, `token-${id}`)
      },


      checkMove(e) {
        return !(e.button === 0 && e.altKey)
      },

      handler(e) {
        this.position = mousePosition(e)
        e.preventDefault()
      },

      createApp() {
        this.app = new Application({
          width: this.windowWidth,
          height: this.windowHeight,
          view: this.$refs.renderCanvas,
          antialias: true,
          transparent: true,
          resolution: 1,
          interactive: true,
        })
      },

      initContainers() {
        this.mapContainer = new Container()
        this.mapContainer.width = this.windowWidth
        this.mapContainer.height = this.windowHeight

        this.gridContainer = new Container()
        this.gridContainer.width = this.windowWidth
        this.gridContainer.height = this.windowHeight

        this.gmContainer = new Container()
        this.gmContainer.width = this.windowWidth
        this.gmContainer.height = this.windowHeight

        this.playersContainer = new Container()
        this.playersContainer.width = this.windowWidth
        this.playersContainer.height = this.windowHeight
      },

      showContainers() {
        this.app.stage.addChild(this.mapContainer, this.gridContainer, this.gmContainer, this.playersContainer)
      },

      changeBackground() {
        if (!this.currentPage.backgroundUrl) {
          return this.mapContainer.removeChildren()
        }

        const loader = new Loader()
        loader.add('background', this.currentPage.backgroundUrl)

        loader.load((loader, resources) => {
          const texture = resources.background.texture
          const sprite = this.backgroundSprite(texture)
          if (this.width) {
            sprite.scale.x = this.width / texture.orig.width
          } else {
            if (texture.orig.width > this.windowWidth) {
              this.mapContainer.width = texture.orig.width
            }
          }

          if (this.height) {
            sprite.scale.y = this.height / texture.orig.height
          } else {
            if (texture.orig.height > this.windowHeight) {
              this.mapContainer.height = texture.orig.height
            }
          }

          if (!this.mapContainer.getChildByName('background')) this.mapContainer.addChild(sprite)
        })
      },

      backgroundSprite(texture) {
        let sprite = this.mapContainer.getChildByName('background')
        if (sprite) {
          sprite.texture = texture
          sprite.width = texture.orig.width
          sprite.height = texture.orig.height
        } else {
          sprite = new TilingSprite(texture, texture.orig.width, texture.orig.height)
          sprite.name = 'background'
        }

        return sprite
      },

      drawGrid() {
        this.gridContainer.removeChildren()
        if (!this.grid.type) return

        if (this.grid.type === 'cell') {
          const stand = new Graphics()
          const width = this.grid.width
          const height = this.grid.height
          let offsetW = 1
          let offsetH = 1
          const wEl = Math.round(this.width / width)
          const hEl = Math.round(this.height / height)

          if (wEl >= hEl) {
            for (let contW = 1; wEl >= contW; contW++) {
              for (let contH = 1; hEl >= contH; contH++) {
                this.cell(stand, width, height, offsetW, offsetH)
                offsetH += height
              }

              offsetH = 1
              offsetW += width
            }
          } else {
            for (let contH = 1; hEl >= contH; contH++) {
              for (let contW = 1; wEl >= contW; contW++) {
                this.cell(stand, width, height, offsetW, offsetH)
                offsetW += width
              }
            }

            offsetW = 1
            offsetH += height
          }

          this.gridContainer.addChild(stand)
        }
      },

      cell(stand, width, height, offsetW, offsetH) {
        const color = this.grid.color
        stand.beginFill(0, 0)
        stand.lineStyle(1, rgbToXhex(color), color.a)
        stand.drawRect(offsetW, offsetH, width - 1, height - 1)
        stand.endFill()
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .pan-zoom-body {
    position: absolute;
  }

  .loaded {
    position: absolute;
    z-index: 2;
    width: 100%;
    height: 100%;
    background: $white;
  }
</style>
