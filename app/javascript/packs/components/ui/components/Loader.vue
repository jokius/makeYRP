<template>
  <div class="text-center">
    <v-progress-circular
      :size="50"
      color="primary"
      indeterminate
    />
  </div>
</template>

<style scoped>
  .v-progress-circular {
    margin: 1rem;
  }
</style>

<script>
  export default {
    name: 'Loader',
  }
</script>
