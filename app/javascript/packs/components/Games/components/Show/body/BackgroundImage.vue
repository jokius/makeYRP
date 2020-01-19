<template>
  <v-zoomer class="zoomer" :double-click-to-zoom="false">
    <img
      :src="background.image.versions.url"
      class="image"
      alt="map"
    />
  </v-zoomer>
</template>

<script>
  import { mapState } from 'vuex'

  export default {
    name: 'BackgroundImage',

    computed: {
      ...mapState({
        currentPage: state => state.game.currentPage,
      }),

      background: {
        get() {
          return this.currentPage.params.background
        },
      },
    },
  }
</script>

<style scoped lang="scss">
  .zoomer {
    width: 100%;
    height: 100%;
    padding-right: 20px;
    padding-left: 20px;
    padding-top: 20px;
    text-align: center;
  }

  .image {
    object-fit: contain;
  }
</style>
