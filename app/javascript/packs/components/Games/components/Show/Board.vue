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
  import { loadGraphics, loadTokens } from '../../api'
  import { UPDATE_CURRENT_RIGHT_CLICK_MENU } from '../../stores/mutation-types'
  import { Token } from '../../../../lib/pixi/Token'
  import BodyLoader from '../../../ui/components/Loader'
  import { BoardContainer } from '../../../../lib/pixi/BoardContainer'
  import { EventObserver } from '../../../../lib/pixi/EventObserver'
  import { Graphic } from '../../../../lib/pixi/Graphic'
  import { GraphicModel } from '../../../../models/GraphicModel'

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
        graphics: {},
        position: { x: 0, y: 0 },
        menuItems: [],
        item: {},
        loaded: false,
        selectRect: {},
        observer: new EventObserver(),
      }
    },

    channels: {
      PageChannel: {
        received(obj) {
          if (obj.delete) {
            this.deleteObj(obj)
          } else if (obj.update) {
            this.changeObj(obj)
          } else {
            this.addObj(obj)
          }
        },
      },
    },

    computed: {
      ...mapState({
        currentPage: state => state.game.currentPage,
        sheets: state => state.game.sheets,
        currentLayer: state => state.game.currentLayer,
        currentCursor: state => state.game.currentCursor,
        borderSize: state => state.game.borderSize,
        borderColor: state => state.game.borderColor,
        bodyColor: state => state.game.bodyColor,
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

      layer: {
        get() {
          return `${this.currentLayer}Container`
        },
      },
    },

    watch: {
      params() {
        this.mapContainer.changeBackground(this.backgroundUrl, this.width, this.height)
        this.gridContainer.drawGrid(this.grid, this.width, this.height)
      },

      currentCursor() {
        this.containersBroadcast()
      },

      currentLayer() {
        this.containersBroadcast()
      },

      borderSize() {
        this.containersBroadcast()
      },

      borderColor() {
        this.containersBroadcast()
      },

      bodyColor() {
        this.containersBroadcast()
      },
    },

    mounted() {
      const pageId = this.currentPage.id
      this.$cable.subscribe({ channel: 'PageChannel', page_id: pageId })
      this.loadBoard()
      this.loadTokens(pageId)
      this.loadGraphics(pageId)
    },

    methods: {
      containersBroadcast() {
        this.observer.broadcast({
          layer: this.layer,
          container: this[this.layer],
          cursor: this.currentCursor,
          borderSize: this.borderSize,
          borderColor: this.borderColor,
          bodyColor: this.bodyColor,
        })
      },

      handleDrop({ sheet }, e) {
        const position = mousePosition(e)
        this.add({ sheet_id: sheet.id, position_x: position.x, position_y: position.y - this.gridWidth, type: 'token' })
      },

      checkMove(e) {
        return !(e.button === 0 && e.altKey)
      },

      handler(e) {
        this.position = mousePosition(e)
        e.preventDefault()
      },

      addObj(obj) {
        if (obj.token) this.tokens.add(obj.token)
        if (obj.graphic) this.graphics.add(obj.graphic, this[obj.graphic.layer])
      },

      changeObj(obj) {
        if (obj.token) this.tokens.change(obj.token)
        if (obj.graphic) this.graphics.change(obj.graphic, this[obj.graphic.layer])
      },

      deleteObj(obj) {
        if (obj.token) {
          const sprite = this.playersContainer.getChildByName(`token_${obj.token.id}`)
          this.playersContainer.removeChild(sprite)
        }
        if (obj.graphic) {
          const container = this[obj.graphic.layer]
          const sprite = container.getChildByName(`graphic_${obj.graphic.id}`)
          container.removeChild(sprite)
        }
      },

      add(params) {
        this.$cable.perform({
          channel: 'PageChannel',
          action: 'add',
          data: { ...params },
        })
      },

      move(params) {
        this.$cable.perform({
          channel: 'PageChannel',
          action: 'change',
          data: { ...params },
        })
      },

      remove(params) {
        this.$cable.perform({
          channel: 'PageChannel',
          action: 'remove',
          data: { ...params },
        })
      },

      loadBoard() {
        this.createApp()
        this.initContainers()
        this.showContainers()
      },

      tokenRightMenu(id) {
        this.menuItems = [{ title: 'Удалить токен', callback: () => this.remove({ id, type: 'token' }) }]
        this.item = { type: 'token', id }
        this.$store.commit(UPDATE_CURRENT_RIGHT_CLICK_MENU, `token-${id}`)
      },

      graphicRightMenu(id) {
        this.menuItems = [{ title: 'Удалить рисунок', callback: () => this.remove({ id, type: 'graphic' }) }]
        this.item = { type: 'graphic', id }
        this.$store.commit(UPDATE_CURRENT_RIGHT_CLICK_MENU, `graphic-${id}`)
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
        this.initContainer('mapContainer')
        this.initContainer('gridContainer')
        this.initContainer('gmContainer')
        this.initContainer('playersContainer')

        this.mapContainer.changeBackground(this.backgroundUrl, this.width, this.height)
        this.gridContainer.drawGrid(this.grid, this.width, this.height)
      },

      initContainer(name) {
        this[name] = new BoardContainer({
          name,
          observer: this.observer,
          addEvents: name === this.layer,
          sendGraphic: this.add,
        })
      },

      showContainers() {
        this.app.stage.addChild(this.mapContainer, this.gmContainer, this.playersContainer, this.gridContainer)
      },

      loadTokens(pageId) {
        this.tokens = new Token(this.sheets, this.grid, this.tokenRightMenu, this.playersContainer, this.move)

        loadTokens(pageId).then(tokens => {
          tokens.forEach(token => this.tokens.add(token))
          this.loaded = true
        })
      },

      loadGraphics(pageId) {
        this.graphics = new Graphic(this.graphicRightMenu, this.move)

        loadGraphics(pageId).then(graphics => {
          graphics.forEach(raw => {
            const graphic = new GraphicModel().setInfo(raw)
            this.graphics.add(graphic, this[graphic.layer])
          })
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
