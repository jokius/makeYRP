<template>
  <div :class="['grid-message', resultColors[resultKey].boardColor]">
    <div :class="['title-block', resultColors[resultKey].titleColor]">
      <span class="title-body">{{ body.name }}</span>
    </div>
    <v-tooltip top>
      <template v-slot:activator="{ on }">
        <p class="number" v-on="on">{{ result }}</p>
      </template>
      <div v-html="fullResult" />
    </v-tooltip>

    <div v-if="results">
      <div class="result-text" v-html="results[resultKey]" />
      <div v-if="result > 6 && details" class="details-text" v-html="details" />
    </div>
  </div>
</template>

<script>
  export default {
    name: 'HmwRoll',

    props: {
      body: { type: Object, required: true },
    },

    data() {
      return {
        resultColors: {
          full: {
            boardColor: 'green-board',
            titleColor: 'green-body',
          },
          part: {
            boardColor: 'gray-board',
            titleColor: 'gray-body',
          },
          fail: {
            boardColor: 'red-board',
            titleColor: 'red-body',
          },
        },
      }
    },

    computed: {
      results: {
        get() {
          return this.body.results
        },
      },

      characteristic: {
        get() {
          return this.body.characteristic
        },
      },

      modifier: {
        get() {
          return this.body.modifier
        },
      },

      details: {
        get() {
          return this.body.details
        },
      },

      dices: {
        get() {
          return this.body.dices.d6
        },
      },

      result: {
        get() {
          const dices = this.dices.reduce((accumulator, dice) => accumulator + dice)
          let characteristicResult = this.characteristic.value
          if (this.characteristic.injury.enable) characteristicResult -= 1
          return dices + characteristicResult + this.modifier
        },
      },

      resultKey: {
        get() {
          const result = this.result
          if (result >= 10) return 'full'
          else if (result <= 6) return 'fail'
          else return 'part'
        },
      },

      fullResult: {
        get() {
          let message = `<div>бросок: ${this.dices.join('+')}</div>`
          message += `<div>${this.characteristic.name}: ${this.characteristic.value}</div>`
          if (this.characteristic.injury.enable) message += `${this.characteristic.injury.name}`
          message += `<div>модификатор: ${this.modifier}</div>`

          return message
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

  .gray-board {
    border: 1px solid $gray42;
  }

  .red-board {
    border: 1px solid $red61;
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

  .gray-body {
    background-color: $gray42;
  }

  .red-body {
    background-color: $red61;
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
