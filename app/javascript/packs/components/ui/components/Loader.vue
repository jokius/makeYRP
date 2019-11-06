<template>
  <v-progress-circular
    class="center"
    :size="50"
    color="indigo"
    indeterminate
  />
</template>

<script>
  export default {
    name: 'Loader',
  }
</script>

<style scoped>
  .v-progress-circular {
    margin: 1rem;
  }

  .center {
    position: fixed;
    top: 50%;
    left: 50%;
  }
</style>
