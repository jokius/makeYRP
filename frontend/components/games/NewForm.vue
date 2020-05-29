<template>
  <v-content>
    <v-container
      class="fill-height"
      fluid
    >
      <v-row align="center" justify="center">
        <v-col cols="12">
          <v-card class="elevation-12">
            <v-toolbar color="indigo" dark flat>
              <v-toolbar-title>Создать игру</v-toolbar-title>
            </v-toolbar>
            <v-card-text>
              <v-form>
                <v-text-field
                  v-model="name"
                  required
                  label="Название"
                />

                <v-select
                  v-model="systemId"
                  :items="systems"
                  label="Standard"
                />
              </v-form>
            </v-card-text>
            <v-card-actions>
              <nuxt-link :to="gamesLink">К списку игр</nuxt-link>
              <v-spacer />
              <v-btn
                :disabled="!isValid"
                color="indigo"
                dark
                @click="save"
              >
                Добавить
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </v-content>
</template>

<script>
  import { mapState } from 'vuex'
  import links from '../../lib/links'

  export default {

    props: { list: { type: Array, required: true } },

    data: () => ({
      gamesLink: links.base.home,
      game: {
        system_id: null,
        name: null,
      },
    }),

    computed: {
      ...mapState({
        games: state => state.games,
      }),

      isValid() {
        return (this.name && this.name !== '') && (this.systemId && this.systemId !== '')
      },

      name: {
        get() {
          return this.game.name
        },
        set(value) {
          this.game.name = value
        },
      },

      systemId: {
        get() {
          return this.game.system_id
        },
        set(value) {
          this.game.system_id = value
        },
      },

      systems() {
        return this.list.map(item => ({ text: item.name, value: item.id }))
      },
    },

    methods: {
      save() {
        if (this.isValid) {
          this.$store.commit('games/updateGameId', null)
          this.$store.dispatch('games/create', { axios: this.$axios, params: { ...this.game } }).then(() => {
            if (this.games.id) {
              this.$router.push(links.dynamic(links.base.game, { id: this.games.id }))
            }
          })
        }
      },
    },
  }
</script>
