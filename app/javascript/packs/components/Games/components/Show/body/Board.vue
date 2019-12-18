import { Loader } from "pixi.js"
<template>
  <div class="pan-zoom-body" @contextmenu="handler">
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
      <canvas ref="renderCanvas" />
    </pan-zoom>
  </div>
</template>

<script>
  import { Application, Container, Loader, TilingSprite } from 'pixi.js'
  import { mapState } from 'vuex'

  import { PageModel } from '../../../../../models/PageModel'

  export default {
    name: 'Board',

    data() {
      return {
        app: {},
        baseContainer: {},
      }
    },

    computed: {
      ...mapState({
        currentPage: (state) => state.game.currentPage || new PageModel(),
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
    },

    mounted() {
      this.createApp()
      this.addBaseContainer()
      this.addBackground()
    },

    methods: {
      checkMove(e) {
        return !(e.button === 0 && e.altKey)
      },

      handler(e) {
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
        })
      },

      addBaseContainer() {
        this.baseContainer = new Container()
        this.baseContainer.width = this.windowWidth
        this.baseContainer.height = this.windowHeight
      },

      addBackground() {
        if (!this.currentPage.backgroundUrl) return

        const loader = new Loader()
        loader.add('background', this.currentPage.backgroundUrl)

        loader.load((loader, resources) => {
          const texture = resources.background.texture
          const sprite = new TilingSprite(texture, texture.orig.width, texture.orig.height)
          if (this.width) {
            sprite.scale.x = this.width / texture.orig.width
          } else {
            if (texture.orig.width > this.windowWidth) {
              this.baseContainer.width = texture.orig.width
            }
          }

          if (this.height) {
            sprite.scale.y = this.height / texture.orig.height
          } else {
            if (texture.orig.height > this.windowHeight) {
              this.baseContainer.height = texture.orig.height
            }
          }

          this.baseContainer.addChild(sprite)
          this.app.stage.addChild(this.baseContainer)
        })
      },
    },
  }
</script>

<style scoped lang="scss">
  .pan-zoom-body {
    position: absolute;
  }
</style>
