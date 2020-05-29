<template>
  <v-app id="inspire">

    <signup-form/>
  </v-app>
</template>

<script>
  import SignupForm from '../components/SignupForm'

  export default {
    auth: false,
    components: { SignupForm },
  }
</script>
