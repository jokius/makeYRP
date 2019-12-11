<template>
  <v-app id="inspire">
    <sign-up-form />
  </v-app>
</template>

<script>
  import SignUpForm from '../../components/SignUp/SignUpForm'

  export default {
    name: 'SignUp',
    components: { SignUpForm },
  }
</script>
