<template>
  <div class="grid-message gray-board">
    <div class="title-block gray-body">
      <span class="title-body">{{ body.name }}</span>
    </div>
    <v-tooltip top>
      <template v-slot:activator="{ on }">
        <p class="number" v-on="on">7</p>
      </template>
      <span>Автоматический частичный успех</span>
    </v-tooltip>

    <div v-if="results">
      <div class="result-text" v-html="results.full" />
      <div v-if="details" class="details-text" v-html="details" />
    </div>
  </div>
</template>

<script>
  export default {
    name: 'AutoPart',

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
  @import '~assets/css/colors';

  $border: 3px solid $black;
  $size: 60px;

  .grid-message {
    display: grid;
    grid-template-columns: 1fr;
    grid-auto-rows: auto;
    grid-row-gap: 5px;
    background: $white;
  }

  .gray-board {
    border: 1px solid $gray42;
  }

  .title-block {
    color: $white;
    text-align: center;
  }

  .title-body {
    font-size: 20px;
  }

  .gray-body {
    background-color: $gray42;
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
