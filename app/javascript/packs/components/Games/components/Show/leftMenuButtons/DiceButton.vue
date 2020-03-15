<template>
  <v-speed-dial direction="right" open-on-hover>
    <template v-slot:activator>
      <div class="button">
        <span class="dice dice20">t</span>
      </div>
    </template>
    <div class="grid-dices">
      <div class="dice-line">
        <span class="dice dice4 item button" @click="roll({ d4: 1 })">a</span>
        <span
          v-for="number in 5"
          :key="`dice4-${number}`"
          class="item number button"
          @click="roll({ d4: number })"
        >
          {{ number }}
        </span>
      </div>

      <div class="dice-line">
        <span class="dice dice6 item button" @click="roll({ d6: 1 })">a</span>
        <span
          v-for="number in 5"
          :key="`dice6-${number}`"
          class="item number button"
          @click="roll({ d6: number })"
        >
          {{ number }}
        </span>
      </div>

      <div class="dice-line">
        <span class="dice dice8 item button" @click="roll({ d8: 1 })">a</span>
        <span
          v-for="number in 5"
          :key="`dice8-${number}`"
          class="item number button"
          @click="roll({ d8: number })"
        >
          {{ number }}
        </span>
      </div>

      <div class="dice-line">
        <span class="dice dice10 item button" @click="roll({ d10: 1 })">a</span>
        <span
          v-for="number in 5"
          :key="`dice10-${number}`"
          class="item number button"
          @click="roll({ d10: number })"
        >
          {{ number }}
        </span>
      </div>

      <div class="dice-line">
        <span class="dice dice12 item button" @click="roll({ d12: 1 })">a</span>
        <span
          v-for="number in 5"
          :key="`dice12-${number}`"
          class="item number button"
          @click="roll({ d12: number })"
        >
          {{ number }}
        </span>
      </div>

      <div class="dice-line">
        <span class="dice dice20 item button" @click="roll({ d20: 1 })">a</span>
        <span
          v-for="number in 5"
          :key="`dice20-${number}`"
          class="item number button"
          @click="roll({ d20: number })"
        >
          {{ number }}
        </span>
      </div>

      <div class="dice-line">
        <span class="dice dice10 item button" @click="roll({ d100: 1 })">jj</span>
        <span
          v-for="number in 5"
          :key="`dice100-${number}`"
          class="item number button"
          @click="roll({ d100: number })"
        >
          {{ number }}
        </span>
      </div>
    </div>
  </v-speed-dial>
</template>

<script>
  export default {
    name: 'DiceButton',

    methods: {
      roll(dices) {
        this.$store.dispatch('sendMessage', {
          dices,
          noSystem: true,
        })
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .button {
    width: 30px;
    height: 30px;
    background-color: $white;
    border: 1px solid $black;
    cursor: pointer;
  }

  .dice {
    font-size: 25px;
    text-align: center;
    line-height: 30px;
    vertical-align: middle;
    margin-left: 5px;
  }

  .grid-dices {
    margin-top: 190px;
    margin-left: -22px;
  }

  .dice-line {
    display: inline-flex;
    &:hover {
      .item:first-child {
        background-color: $indigoRGBA;
      }
    }
  }

  .item {
    &:hover {
      background-color: $indigoRGBA;
    }
  }

  .number {
    font-size: 20px;
    text-align: center;
    line-height: 30px;
    vertical-align: middle;
    margin-left: 2px;
  }
</style>
