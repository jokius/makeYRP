<template>
  <div class="grid-message">
    <p class="dices">бросок {{ rollText }}</p>
    <p class="dices-each">{{ eachDices }}</p>
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

      eachDices: {
        get() {
          const message = []
          for ( const key in this.roll) {
            message.push(this.roll[key].join(' + '))
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
  }
</style>
