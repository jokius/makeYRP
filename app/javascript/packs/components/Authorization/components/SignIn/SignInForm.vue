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
              <v-toolbar-title>Вход</v-toolbar-title>
            </v-toolbar>
            <v-card-text>
              <v-form
                ref="form"
                v-model="isValid"
              >
                <v-text-field
                  v-model="inputEmail"
                  required
                  :rules="emailRules"
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
              <router-link :to="signUp">Зарегистрироваться</router-link>
              <v-spacer />
              <v-btn
                :disabled="sending || !isValid"
                color="primary"
                @click="validate"
              >
                Войти
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
  import { signInReq } from '../../api'

  export default {
    data: () => ({
      emailRules,
      requiredRules,
      signUp: links.base.signUp,
      isValid: false,
      email: '',
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

      inputPassword: {
        get() {
          return this.password
        },

        set(value) {
          this.clearErrors()
          this.password = value
        },
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
          signInReq( { email: this.email, password: this.password }).then(() => {
            if (this.isValid) this.$router.push(links.base.home)
          }).catch(error => {
            this.errors = { password: [error.response.data.error] }
          }).finally(() => this.sending = false)
        }
      },
    },
  }
</script>
