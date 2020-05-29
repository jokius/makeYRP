<template>
  <v-card-text>
    <v-card-text class="loader">
      Загрузка данных
      <v-progress-linear
        color="indigo"
        indeterminate
        class="mb-0"
      />
    </v-card-text>
  </v-card-text>
</template>

<script>
  export default {
    name: 'FoldersPreloader',
  }
</script>

<style scoped lang="scss">
  .loader {
    position: relative;
    top: 50%;
  }
</style>
