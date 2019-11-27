<template>
  <v-app id="inspire">
    <v-content v-if="loaded">
      <div class="bodyGrid">
        <head-menu />
        <body-menu />
      </div>
      <open-modals />
    </v-content>
    <loader v-else />
  </v-app>
</template>

<script>
  import { mapState } from 'vuex'

  import HeadMenu from '../../components/Show/HeadMenu'
  import OpenModals from '../../components/Show/OpenModals'
  // import PageContent from '../../components/Show/PageContent'
  import Loader from '../../../ui/components/Loader'
  import BodyMenu from '../../components/Show/BodyMenu'

  export default {
    name: 'ShowGame',
    components: {
      BodyMenu,
      HeadMenu,
      OpenModals,
      // PageContent,
      Loader,
    },

    computed: {
      ...mapState({
        game: (state) => state.game,
      }),

      loaded() {
        return this.game.loaded
      },
    },

    created() {
      this.$store.dispatch('loadGame', this.$route.params.id)
    },
  }
</script>

<style scoped lang="scss">
  .bodyGrid {
    display: grid;
    grid-template-columns: auto max-content;
    grid-gap: 5px;
    position: fixed;
    width: 100vw;
    height: 100vh;
  }
</style>
