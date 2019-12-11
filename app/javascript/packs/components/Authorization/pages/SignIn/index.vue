<template>
  <v-app id="inspire">
    <sign-in-form />
  </v-app>
</template>

<script>
  import SignInForm from '../../components/SignIn/SignInForm'

  export default {
    name: 'SignIn',
    components: { SignInForm },
  }
</script>
