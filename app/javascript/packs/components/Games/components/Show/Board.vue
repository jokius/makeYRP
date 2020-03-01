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
  import { Application } from 'pixi.js'
  import { mapState } from 'vuex'

  import RightClickMenu from './RightClickMenu'

  import { mousePosition } from '../../../../lib/mousePosition'
  import { loadTokens } from '../../api'
  import { UPDATE_CURRENT_RIGHT_CLICK_MENU } from '../../stores/mutation-types'
  import { Token } from '../../../../lib/pixi/Token'
  import BodyLoader from '../../../ui/components/Loader'
  import { BoardContainer } from '../../../../lib/pixi/BoardContainer'

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
        selectRect: {},
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
        currentLayer: state => state.game.currentLayer,
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
          return parseInt(this.grid.width, 10)
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

      grid: {
        get() {
          return this.params.grid
        },
      },

      backgroundUrl: {
        get() {
          return this.currentPage.backgroundUrl
        },
      },
    },

    watch: {
      params() {
        this.mapContainer.changeBackground(this.backgroundUrl, this.width, this.height)
        this.gridContainer.drawGrid(this.grid, this.width, this.height)
      },
    },

    mounted() {
      const pageId = this.currentPage.id
      this.$cable.subscribe({ channel: 'PageChannel', page_id: pageId })
      this.loadBoard()
      this.loadTokens(pageId)
    },

    methods: {
      handleDrop({ sheet }, e) {
        const position = mousePosition(e)
        this.sendToken({ sheet_id: sheet.id, position_x: position.x, position_y: position.y - this.gridWidth })
      },

      checkMove(e) {
        return !(e.button === 0 && e.altKey)
      },

      handler(e) {
        this.position = mousePosition(e)
        e.preventDefault()
      },

      sendToken(params) {
        this.$cable.perform({
          channel: 'PageChannel',
          action: 'add_token',
          data: { ...params },
        })
      },

      loadBoard() {
        this.createApp()
        this.initContainers()
        this.showContainers()
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
        this.initContainer({ name: 'mapContainer', interactive: true })
        this.initContainer({ name: 'gridContainer' })
        this.initContainer({ name: 'gmContainer' })
        this.initContainer({ name: 'playersContainer' })

        this.mapContainer.changeBackground(this.backgroundUrl, this.width, this.height)
        this.gridContainer.drawGrid(this.grid, this.width, this.height)
      },

      initContainer({ name, interactive }) {
        this[name] = new BoardContainer({ interactive })
      },

      showContainers() {
        this.app.stage.addChild(this.mapContainer, this.gridContainer, this.gmContainer, this.playersContainer)
      },

      loadTokens(pageId) {
        this.tokens = new Token(this.sheets, this.grid, this.tokenRightMenu, this.playersContainer,
                                this.showContainers, this.moveToken)

        loadTokens(pageId).then(tokens => {
          tokens.forEach(token => this.tokens.addToken(token))
          this.loaded = true
        })
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
