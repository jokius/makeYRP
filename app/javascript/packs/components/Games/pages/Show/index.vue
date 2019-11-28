<template>
  <v-app id="inspire">
    <v-content v-if="loaded">
      <div class="menu-grid">
        <head-menu class="head-menu" />
        <body-menu class="body-menu" />
        <body-content class="body-content" />
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
  import Loader from '../../../ui/components/Loader'
  import BodyMenu from '../../components/Show/BodyMenu'
  import BodyContent from '../../components/Show/BodyContent'

  export default {
    name: 'ShowGame',
    components: {
      BodyContent,
      BodyMenu,
      HeadMenu,
      OpenModals,
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
  .menu-grid {
    display: grid;
    grid-template-columns: auto auto max-content;
    grid-template-rows: max-content auto;
    grid-gap: 0;
    position: fixed;
    width: 100vw;
    height: 100vh;
    grid-template-areas:
      'head-menu head-menu body-menu'
      'body-content body-content body-menu';
  }

  .head-menu {
    grid-area: head-menu;
  }

  .body-menu {
    grid-area: body-menu;
  }

  .body-content {
    grid-area: body-content;
  }
</style>
