<template>
  <div class="grid-message">
    <p class="dices">бросок {{ rollText }}</p>
    <div v-for="(rolls, dice) in roll" :key="`${dice}-${Date.now}`">
      <div v-for="(value, index) in rolls" :key="`${dice}-${index}-${Date.now}`" class="dice">
        <span :class="dice">{{ valueToSymb(dice, value) }}</span>
        <span v-if="index + 1 < rolls.length" class="plus"> + </span>
      </div>
    </div>
    <p class="dices-sum"> = {{ sum }}</p>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  export default {
    name: 'DefaultRoll',

    props: {
      roll: { type: Object, required: true },
    },

    computed: {
      ...mapState({
        system: state => state.game.info.system,
      }),

      rollText: {
        get() {
          const message = []
          for ( const key in this.roll) {
            message.push(`${this.roll[key].length}${key}`)
          }

          return message.join(' + ')
        },
      },

      sum: {
        get() {
          let message = 0
          for ( const key in this.roll) {
            message = this.roll[key].reduce((accumulator, dice) =>
                                              (accumulator + dice),
                                            message)
          }

          return message
        },
      },
    },

    methods: {
      valueToSymb(dice, value) {
        if (!['d6', 'd8', 'd10', 'd12', 'd20', 'd100'].includes(dice)) return value

        let result = value.toString()

        if (dice === 'd100') {
          return result.split('').map(value => this.replaceNumberToChar(value)).join('')
        }

        if (['d12', 'd20'].includes(dice)) {
          result = result
            .replace('10', 'j')
            .replace('11', 'k')
            .replace('12', 'l')
            .replace('13', 'm')
            .replace('14', 'n')
            .replace('15', 'o')
            .replace('16', 'p')
            .replace('17', 'q')
            .replace('18', 'r')
            .replace('19', 's')
            .replace('20', 'T')
        }

        return result
          .replace('1', 'a')
          .replace('2', 'b')
          .replace('3', 'c')
          .replace('4', 'd')
          .replace('5', 'e')
          .replace('6', 'f')
          .replace('7', 'g')
          .replace('8', 'h')
          .replace('9', 'i')
      },

      replaceNumberToChar(value) {
        return value
          .replace('0', 'a')
          .replace('1', 'b')
          .replace('2', 'c')
          .replace('3', 'd')
          .replace('4', 'e')
          .replace('5', 'f')
          .replace('6', 'g')
          .replace('7', 'h')
          .replace('8', 'i')
          .replace('9', 'j')
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
  }

  .dice {
    display: inline-flex;
  }

  .plus {
    font-size: 30px;
    position: relative;
    top: 14px;
    right: 4px;
  }

  .d4 {
    font-size: 50px;
  }

  .d6 {
    font-size: 50px;
  }

  .d8 {
    font-size: 50px;
  }

  .d10 {
    font-size: 50px;
  }

  .d12 {
    font-size: 50px;
  }

  .d20 {
    font-size: 50px;
  }

  .d100 {
    font-size: 50px;
  }

</style>
