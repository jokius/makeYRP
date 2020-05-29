<template>
  <v-app id="inspire">
    <v-content v-if="user">
      <v-container class="fill-height" fluid>
        <div class="user-grid">
          <v-avatar :key="user.id" size="36" color="indigo">
            <img
              v-if="user.avatar.thumb"
              :src="user.avatar.thumb"
              :alt="user.nickname"
            />
            <v-icon v-if="!user.avatar.thumb" dark>mdi-account-circle</v-icon>
          </v-avatar>
          <v-btn
            tile
            color="indigo"
            dark
            @click="logout"
          >
            Выйти
          </v-btn>
        </div>
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
  import Actions from '../../components/games/Actions'
  import Tabs from '../../components/games/Tabs'
  import Loader from '../../components/Loader'

  export default {
    components: { Loader, Tabs, Actions },

    created() {
      this.$store.dispatch('games/load', this.$axios)
    },

    computed: {
      ...mapState({
        games: state => state.games,
        loaded: state => state.games.loaded,
        user: state => state.auth.user,
      }),
    },

    methods: {
      logout: function () {
        this.$auth.logout().catch(e => {this.error = e + ''}).then(() => this.$router.push('/login'))
      }
    },
  }
</script>

<style scoped lang="scss">
  .user-grid {
    align-self: end;
    position: absolute;
    right: 5px;
  }
</style>
