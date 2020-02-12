<template>
  <v-app id="inspire">
    <v-content>
      <v-container class="fill-height" fluid>
        <v-row align="center" justify="center">
          <v-col cols="12">
            <loader v-if="!loaded" />
            <games-list v-if="loaded" :games="games.list" />
          </v-col>
        </v-row>
      </v-container>
    </v-content>
  </v-app>
</template>

<script>
  import { mapState } from 'vuex'

  import GamesList from '../../components/Index/GamesList'
  import Loader from '../../../../ui/components/Loader'

  export default {
    name: 'Games',
    components: { GamesList, Loader },
    computed: {
      ...mapState({
        games: state => state.adminGames,
      }),

      loaded() {
        return this.games.loaded
      },
    },
    created() {
      this.$store.dispatch('loadAdminGames')
    },
  }
</script>
