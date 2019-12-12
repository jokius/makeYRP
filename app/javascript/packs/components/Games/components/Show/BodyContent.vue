<template>
  <div class="map-body" :style="style">
    <background-image v-if="background.image" />
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import BackgroundImage from './body/BackgroundImage'

  import { PageModel } from '../../../../models/PageModel'

  export default {
    name: 'BodyContent',
    components: { BackgroundImage },

    computed: {
      ...mapState({
        currentPage: (state) => state.game.currentPage,
      }),

      background: {
        get() {
          const params = this.currentPage.params || new PageModel().defaultParams
          return params.background
        },
      },

      style: {
        get() {
          return {
            backgroundColor: this.background.color,
          }
        },
      },
    },
  }
</script>

<style scoped lang="scss">
  .map-body {
    width: 100%;
    height: 100%;
  }
</style>
