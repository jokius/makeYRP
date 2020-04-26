<template>
  <div class="grid-message gray-board">
    <div class="title-block gray-body">
      <span class="title-body">Урон</span>
    </div>
    <v-tooltip top>
      <template v-slot:activator="{ on }">
        <p class="number" v-on="on">{{ damage }}</p>
      </template>
      <span>{{ dicesResult }}</span>
    </v-tooltip>
  </div>
</template>

<script>
  export default {
    name: 'DamageRoll',

    props: {
      body: { type: Object, required: true },
    },

    computed: {
      results: {
        get() {
          return this.body.results
        },
      },

      dices: {
        get() {
          return this.body.dices.d6
        },
      },

      dicesResult: {
        get() {
          return this.dices.join(', ')
        },
      },

      damage: {
        get() {
          let damage = 0
          this.dices.forEach(dice => {
            if (dice === 6) damage += 2
            else if (dice >= 4) damage += 1
            else damage += 0.5
          })

          return Math.floor(damage)
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
