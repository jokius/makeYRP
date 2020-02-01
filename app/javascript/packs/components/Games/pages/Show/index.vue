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
  import { ADD_MESSAGE, ADD_SHEET, DELETE_SHEET, UPDATE_SHEETS } from '../../stores/mutation-types'

  export default {
    name: 'ShowGame',
    components: {
      BodyContent,
      BodyMenu,
      HeadMenu,
      OpenModals,
      Loader,
    },

    data() {
      return {
        overlay: false
      }
    },

    channels: {
      ChatChannel: {
        connected() {
          this.overlay = false
        },
        disconnected() {
          this.overlay = true
        },

        received(message) {
          this.$store.commit(ADD_MESSAGE, message)
        },
      },

      SheetsChannel: {
        received(obj) {
          if (obj.delete) {
            this.$store.commit(DELETE_SHEET, obj.delete)
          } else {
            if (obj.new){
              this.$store.commit(ADD_SHEET, obj.sheet)
            } else {
              this.$store.commit(UPDATE_SHEETS, obj.sheet)
            }
          }
        },
      },
    },

    computed: {
      ...mapState({
        game: state => state.game,
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
        channel: 'ChatChannel',
        game_id: gameId,
      })

      this.$cable.subscribe({
        channel: 'SheetsChannel',
        game_id: gameId,
      })
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

  .body-content {
    grid-area: body-content;
    position: relative;
    z-index: 1;
  }
</style>
