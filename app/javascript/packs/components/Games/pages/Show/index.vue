<template>
  <v-app id="inspire">
    <v-content v-if="loaded">
      <left-menu />
      <div class="menu-grid">
        <head-menu class="head-menu" />
        <body-menu class="body-menu" />
        <body-content class="body-content" />
      </div>
      <open-modals />
    </v-content>
    <loader v-else />

    <v-overlay :value="overlay">
      <v-card>
        <v-card-text class="disconnect-message">
          <h1>Соединение с сервером потерено</h1>
          <p>Обновите страницу либо подождите востонавления соеденения</p>
        </v-card-text>
      </v-card>
    </v-overlay>
  </v-app>
</template>

<script>
  import { mapState } from 'vuex'

  import HeadMenu from '../../components/Show/HeadMenu'
  import OpenModals from '../../components/Show/OpenModals'
  import Loader from '../../../ui/components/Loader'
  import BodyMenu from '../../components/Show/BodyMenu'
  import BodyContent from '../../components/Show/BodyContent'
  import {
    ACCESS_SHEET,
    ADD_MENU_ITEM,
    ADD_MESSAGE,
    ADD_PAGE,
    ADD_SHEET,
    DELETE_PAGE,
    DELETE_SHEET,
    UPDATE_PAGE,
    UPDATE_SHEETS,
  } from '../../stores/mutation-types'
  import LeftMenu from '../../components/Show/LeftMenu'

  export default {
    name: 'ShowGame',
    components: {
      LeftMenu,
      BodyContent,
      BodyMenu,
      HeadMenu,
      OpenModals,
      Loader,
    },

    data() {
      return {
        overlay: false,
      }
    },

    channels: {
      GameChannel: {
        connected() {
          this.overlay = false
        },
        disconnected() {
          this.overlay = true
        },

        received(obj) {
          if (obj.new) this.addObj(obj)
          if (obj.update) this.updateObj(obj)
          if (obj.delete) this.deleteObj(obj)
          if (obj.access) this.accessObj(obj)
        },
      },
    },

    computed: {
      ...mapState({
        game: state => state.game,
        marks: state => state.game.marks,
      }),

      loaded() {
        return this.game.loaded
      },
    },

    created() {
      this.$store.dispatch('loadGame', this.$route.params.id)
    },

    mounted() {
      const gameId = this.$route.params.id

      this.$cable.subscribe({
        channel: 'GameChannel',
        game_id: gameId,
      })
    },

    methods: {
      addObj(obj) {
        if (obj.sheet) this.$store.commit(ADD_SHEET, obj.sheet)
        if (obj.page) this.$store.commit(ADD_PAGE, obj.page)
        if (obj.menu_item) this.$store.commit(ADD_MENU_ITEM, obj.menu_item)
        if (obj.message) this.addMessage(obj.message)
      },

      updateObj(obj) {
        if (obj.sheet) this.$store.commit(UPDATE_SHEETS, obj.sheet)
        if (obj.page) this.$store.commit(UPDATE_PAGE, obj.page)
      },

      deleteObj(obj) {
        if (obj.sheet) this.$store.commit(DELETE_SHEET, obj.sheet)
        if (obj.page) this.$store.commit(DELETE_PAGE, obj.page)
      },

      accessObj(obj) {
        if (obj.sheet) this.$store.commit(ACCESS_SHEET, obj.sheet)
      },

      addMessage(message) {
        this.$store.commit(ADD_MESSAGE, message)
        const audio = new Audio('/sounds/intuition.mp3')
        audio.play()
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .disconnect-message {
    text-align: center;

    h1 {
      font-size: 2em;
    }
  }

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
    position: relative;
    z-index: 2;
    background-color: $white;
  }

  .body-menu {
    grid-area: body-menu;
    position: relative;
    z-index: 2;
  }

  .left-menu {
    position: absolute;
    z-index: 2;
  }

  .body-content {
    grid-area: body-content;
    position: relative;
    z-index: 1;
  }
</style>
