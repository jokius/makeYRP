<template>
  <v-app id="inspire">
    <v-content v-if="loaded">
      <head-menu />
      <left-menu-body v-if="game.currentMenu >= 0" />
      <!--      <page-content />-->
      <open-modals />
    </v-content>
    <loader v-else />
  </v-app>
</template>

<script>
  import { mapState } from 'vuex'

  import HeadMenu from '../../components/Show/HeadMenu'
  import LeftMenuBody from '../../components/Show/LeftMenuBody'
  import OpenModals from '../../components/Show/OpenModals'
  // import PageContent from '../../components/Show/PageContent'
  import Loader from '../../../ui/components/Loader'

  export default {
    name: 'ShowGame',
    components: {
      HeadMenu,
      LeftMenuBody,
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
