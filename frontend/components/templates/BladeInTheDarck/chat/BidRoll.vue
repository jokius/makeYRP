<template>
  <div class="grid-message">
    <div class="dice-pool">
      <div
        v-for="(dice, index) in roll.d6"
        :key="`d6-${index}`"
        class="d6 dice"
      >
        <span class="text">{{ dice }}</span>
      </div>
    </div>
    <p class="name"><b>{{ name }}</b></p>
    <p>Лучшее значение: {{ bestValue }}</p>
    <p>Худшее значение: {{ worstValue }}</p>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  export default {
    name: 'BidRoll',

    props: {
      roll: { type: Object, required: true },
      name: { type: String, required: true },
    },

    computed: {
      ...mapState({
        system: state => state.game.info.system,
      }),

      bestValue: {
        get() {
          let message = ''
          const d6 = this.roll.d6
          const impressiveSuccess = d6.filter(item => item === 6).length === 2
          const maxValue = Math.max(...d6)
          if (impressiveSuccess) {
            message = '6&6: впечатляющий успех'
          } else if (maxValue === 6) {
            message = '6: полный успех'
          } else if (maxValue >= 4) {
            message = `${maxValue}: частичный успех`
          } else {
            message = `${maxValue}: провал`
          }

          return message
        },
      },

      worstValue: {
        get() {
          let message = ''
          const d6 = this.roll.d6
          const impressiveSuccess = d6.filter(item => item === 6).length === 2
          const minValue = Math.min(...d6)
          if (minValue === 6 && impressiveSuccess) {
            message = '6&6: впечатляющий успех'
          } else if (minValue === 6) {
            message = '6: полный успех'
          } else if (minValue >= 4) {
            message = `${minValue}: частичный успех`
          } else {
            message = `${minValue}: провал`
          }

          return message
        },
      },
    },
  }
</script>

<style scoped lang="scss">
  @import '~assets/css/colors';

  $size: 60px;

  .grid-message {
    display: grid;
    grid-template-columns: 1fr;
    grid-auto-rows: auto;
    grid-row-gap: 5px;
  }

  .dice-pool {
    display: flex;
    flex-flow: wrap;
  }

  .dice {
    margin: 1px;
    width: $size;
    height: $size;
  }

  .text {
    font-size: 50px;
    position: relative;
    bottom: 10px;
    left: 8px;
  }

  .d6 {
    border-radius: 8px;
    border: 3px solid $black;
    background-color: $black;
    color: $white;
  }
</style>
