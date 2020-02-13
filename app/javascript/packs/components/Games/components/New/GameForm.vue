<template>
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
          <v-card class="elevation-12">
            <v-toolbar
              color="indigo"
              dark
              flat
            >
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
                  v-model="system_id"
                  :items="systems"
                  label="Standard"
                />
              </v-form>
            </v-card-text>
            <v-card-actions>
              <router-link :to="games">К списку игр</router-link>
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

  import links from '../../../../helpers/links'
  import { UPDATE_NAME, UPDATE_SYSTEM_ID } from '../../stores/mutation-types'

  export default {
    name: 'GameForm',
    props: { list: { type: Array, required: true } },

    data: () => ({
      games: links.base.home,
    }),

    computed: {
      ...mapState({
        game: state => state.newGame,
      }),

      isValid() {
        return (this.name && this.name !== '') && (this.system_id && this.system_id !== '')
      },

      name: {
        get() {
          return this.game.name
        },
        set(value) {
          this.$store.commit(UPDATE_NAME, value)
        },
      },

      systems() {
        return this.list.map(item => ({ text: item.name, value: item.id }))
      },

      system_id: {
        get() {
          return this.game.system_id
        },
        set(value) {
          this.$store.commit(UPDATE_SYSTEM_ID, value)
        },
      },
    },

    methods: {
      save() {
        if (this.isValid) {
          this.$store.dispatch('createGame', { ...this.game }).then(() => {
            if (this.game.id) {
              this.$router.push(links.dynamic(links.base.game, { id: this.game.id }))
            }
          })
        }
      },
    },
  }
</script>
