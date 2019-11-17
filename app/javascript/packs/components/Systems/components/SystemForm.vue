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
              color="primary"
              dark
              flat
            >
              <v-toolbar-title>Добавить систему</v-toolbar-title>
            </v-toolbar>
            <v-card-text>
              <v-form>
                <v-text-field
                  v-model="name"
                  required
                  label="Название"
                />
                <v-textarea
                  v-model="text"
                  label="Загрузка текстом"
                  auto-grow
                />

                <v-file-input
                  v-model="files"
                  accept="application/json"
                  label="Загрузка файлом"
                />
              </v-form>
            </v-card-text>
            <v-card-actions>
              <router-link :to="games">К списку игр</router-link>
              <v-spacer />
              <v-btn
                :disabled="!isValid"
                color="primary"
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

  import {
    UPDATE_NAME,
    UPDATE_TEXT,
    UPDATE_FILE,
  } from '../stores/mutation-types'
  import links from '../../../helpers/links'

  export default {
    name: 'SystemForm',
    data: () => ({
      games: links.base.home,
    }),

    computed: {
      ...mapState({
        system: (state) => state.newSystem,
      }),

      isValid() {
        return (this.name && this.name !== '') &&
          ((this.text && this.text !== '') || (this.files && this.files['name']))
      },

      name: {
        get() {
          return this.system.name
        },
        set(value) {
          this.$store.commit(UPDATE_NAME, value)
        },
      },

      text: {
        get() {
          return this.system.text
        },
        set(value) {
          this.$store.commit(UPDATE_TEXT, value)
        },
      },

      files: {
        get() {
          return this.system.files
        },

        set(value) {
          this.$store.commit(UPDATE_FILE, value)
        },
      },
    },

    methods: {
      save() {
        if (this.isValid) {
          this.$store.dispatch('addSystem', { ...this.system }).then(() => {
            this.$router.push(links.base.home)
          })
        }
      },
    },
  }
</script>
