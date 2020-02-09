<template>
  <v-app id="inspire">
    <v-content>
      <v-container
        class="fill-height"
        fluid
      >
        <v-row
          align="center"
          justify="center"
        >
          <v-col
            cols="12"
            sm="8"
            md="4"
          >
            <loader v-if="!loaded" />
            <actions v-if="loaded" />
            <tabs v-if="loaded" />
          </v-col>
        </v-row>
      </v-container>
    </v-content>
  </v-app>
</template>

<script>
  import { mapState } from 'vuex'

  import Actions from '../../components/Index/Actions'
  import Tabs from '../../components/Index/Tabs'
  import Loader from '../../../ui/components/Loader'

  export default {
    name: 'Games',
    components: { Actions, Tabs, Loader },
    computed: {
      ...mapState({
        games: state => state.games,
        currentUser: state => state.currentUser,
      }),

      loaded() {
        return this.games.loaded && this.currentUser.loaded
      },
    },
    created() {
      if (!this.currentUser.loaded) {
        this.$store.dispatch('loadCurrentUser', { full: false })
      }
      this.$store.dispatch('loadGames')
    },
  }
</script>
