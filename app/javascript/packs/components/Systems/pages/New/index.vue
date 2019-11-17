<template>
  <v-app id="inspire">
    <system-form />
  </v-app>
</template>

<script>
  import SystemForm from '../../components/SystemForm'

  export default {
    name: 'NewSystem',
    components: { SystemForm },
  }
</script>
