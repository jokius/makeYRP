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
            <v-card class="elevation-12">
              <v-toolbar
                color="primary"
                dark
                flat
              >
                <v-toolbar-title>Регистрация</v-toolbar-title>
              </v-toolbar>
              <v-card-text>
                <v-form
                  ref="form"
                  v-model="isValid"
                >
                  <v-text-field
                    v-model="nickname"
                    required
                    :rules="requiredRules"
                    label="Ник"
                    prepend-icon="mdi-account"
                  />

                  <v-text-field
                    v-model="email"
                    required
                    :rules="emailRules"
                    :error-messages="asyncEmailErrors"
                    label="Email"
                    prepend-icon="mdi-email"
                  />

                  <v-text-field
                    v-model="password"
                    required
                    :rules="requiredRules"
                    :error-messages="asyncPasswordErrors"
                    label="Пароль"
                    prepend-icon="mdi-lock"
                    type="password"
                  />
                </v-form>
              </v-card-text>
              <v-card-actions>
                <router-link :to="logIn">Войти</router-link>
                <v-spacer />
                <v-btn
                  :disabled="!isValid"
                  color="primary"
                  @click="validate"
                >
                  Зарегестрироватся
                </v-btn>
              </v-card-actions>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </v-content>
  </v-app>
</template>

<script>
  import { mapState } from 'vuex'

  import {
    UPDATE_EMAIL,
    UPDATE_IS_VALID,
    UPDATE_NICKNAME,
    UPDATE_PASSWORD,
  } from '../store/mutation-types'
  import links from '../../../../helpers/links'

  const requiredField = (v) => !!v || 'обязательное поле'

  export default {
    data: () => ({
      logIn: links.base.signUp,
      emailRules: [
        requiredField,
        (v) => /.+@.+\..+/.test(v) || 'E-mail не корректен',
      ],
      requiredRules: [
        requiredField,
      ],
    }),

    computed: {
      ...mapState({
        store: (state) => state.signUp,
      }),

      isValid: {
        get() {
          return this.store.isValid
        },
        set(value) {
          this.$store.commit(UPDATE_IS_VALID, value)
        },
      },

      nickname: {
        get() {
          return this.store.nickname
        },
        set(value) {
          this.$store.commit(UPDATE_NICKNAME, value)
        },
      },

      email: {
        get() {
          return this.store.email
        },
        set(value) {
          this.$store.commit(UPDATE_EMAIL, value)
        },
      },

      password: {
        get() {
          return this.store.password
        },
        set(value) {
          this.$store.commit(UPDATE_PASSWORD, value)
        },
      },

      asyncEmailErrors() {
        const errors = this.store.errors.email || []
        return errors || errors.join(', ')
      },

      asyncPasswordErrors() {
        const errors = this.store.errors.password || []
        return errors || errors.join(', ')
      },
    },

    methods: {
      validate() {
        if (this.$refs.form.validate()) {
          this.$store.dispatch('signUp', { ...this.store }).then(() => {
            if (this.isValid) this.$router.push(links.base.home)
          })
        }
      },
    },
  }
</script>
