<template>
  <div class="grid-message green-board">
    <div class="title-block green-body">
      <span class="title-body">{{ body.name }}</span>
    </div>
    <v-tooltip top>
      <template v-slot:activator="{ on }">
        <p class="number" v-on="on">10</p>
      </template>
      <span>Автоматический успех</span>
    </v-tooltip>

    <div v-if="results">
      <div class="result-text" v-html="results.full" />
      <div v-if="details" class="details-text" v-html="details" />
    </div>
  </div>
</template>

<script>
  export default {
    name: 'AutoFull',

    props: {
      body: { type: Object, required: true },
    },

    computed: {
      results: {
        get() {
          return this.body.results
        },
      },

      details: {
        get() {
          return this.body.details
        },
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  $border: 3px solid $black;
  $size: 60px;

  .grid-message {
    display: grid;
    grid-template-columns: 1fr;
    grid-auto-rows: auto;
    grid-row-gap: 5px;
    background: $white;
  }

  .green-board {
    border: 1px solid $green00;
  }

  .title-block {
    color: $white;
    text-align: center;
  }

  .title-body {
    font-size: 20px;
  }

  .green-body {
    background-color: $green00;
  }

  .number {
    font-weight: bold;
    font-size: 25px;
    margin: 0;
    text-align: center;
    height: 60px;
    line-height: 60px;
  }

  .result-text {
    margin: 0 5px;
  }

  .details-text {
    margin-top: 5px;
    margin-left: 5px;
    margin-right: 5px;
  }
</style>
