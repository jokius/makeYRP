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
  import Loader from '../../../components/Loader'
  import GamesList from '../../../components/admin/games/GamesList'
  import links from '../../../lib/links'

  export default {
    name: 'Games',
    components: { GamesList, Loader },

    computed: {
      ...mapState({
        user: state => state.auth.user,
        games: state => state.admin.games,
      }),

      loaded() {
        return this.games.loaded
      },
    },

    created() {
      if (!this.user.admin) return this.$router.push(links.base.home)

      this.$store.dispatch('admin/games/load', this.$axios)
    },
  }
</script>
