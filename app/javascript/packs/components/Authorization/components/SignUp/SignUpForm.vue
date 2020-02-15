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
              <v-toolbar-title>Регистрация</v-toolbar-title>
            </v-toolbar>
            <v-card-text>
              <v-form
                ref="form"
                v-model="isValid"
              >
                <v-text-field
                  v-model="inputNickname"
                  required
                  :rules="requiredRules"
                  label="Ник"
                  prepend-icon="mdi-account"
                />

                <v-text-field
                  v-model="inputEmail"
                  required
                  :rules="emailRules"
                  :error-messages="asyncEmailErrors"
                  label="Email"
                  prepend-icon="mdi-email"
                />

                <v-text-field
                  v-model="inputPassword"
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
                :disabled="sending || !isValid"
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
</template>

<script>
  import links from '../../../../helpers/links'
  import { emailRules, requiredRules } from '../../lib/validationRules'
  import { signUpReq } from '../../api'

  export default {
    data: () => ({
      emailRules,
      requiredRules,
      logIn: links.base.signIn,
      isValid: false,
      email: '',
      nickname: '',
      password: '',
      errors: {},
      sending: false,
    }),

    computed: {
      inputEmail: {
        get() {
          return this.email
        },

        set(value) {
          this.clearErrors()
          this.email = value
        },
      },

      inputNickname: {
        get() {
          return this.nickname
        },

        set(value) {
          this.clearErrors()
          this.nickname = value
        },
      },

      inputPassword: {
        get() {
          return this.password
        },

        set(value) {
          this.clearErrors()
          this.password = value
        },
      },

      asyncEmailErrors() {
        const errors = this.errors.email || []
        return errors || errors.join(', ')
      },

      asyncPasswordErrors() {
        const errors = this.errors.password || []
        return errors || errors.join(', ')
      },
    },

    methods: {
      clearErrors() {
        this.isValid = true
        this.errors = {}
      },

      validate() {
        if (this.$refs.form.validate()) {
          this.sending = true
          signUpReq({ email: this.email, nickname: this.nickname, password: this.password }).then(() => {
            if (this.isValid) this.$router.push(links.base.home)
          }).catch(error => {
            this.errors = error.response.data.errors
          }).finally(() => this.sending = false)
        }
      },
    },
  }
</script>
