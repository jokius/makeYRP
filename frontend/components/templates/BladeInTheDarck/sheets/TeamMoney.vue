<template>
  <div class="base-money">
    <div class="money-list">
      <span class="inline on-hand-title black">монеты</span>
      <div
        v-for="number in coinsOnHand.max"
        :key="`coinsOnHand-${number}`"
        :class="['inline', 'on-hand', fullBox('coinsOnHand', number)]"
        @click="changeCoins('coinsOnHand', coinsOnHand.current < number)"
      />
      <div class="inline separator" />
      <div
        v-for="number in coinsOnTreasury.max"
        :key="`coinsOnTreasury-${number}`"
        :class="['inline', 'on-treasury', fullBox('coinsOnTreasury', number)]"
        @click="changeCoins('coinsOnTreasury', coinsOnTreasury.current < number)"
      />
      <span class="inline on-treasury-title">сокровищ.</span>
    </div>
    <p class="text-help">
      Шаг в разивтии команды увеличивает содержимое заначки каждого персонажа игрока на ранг+2 монет.
    </p>
  </div>
</template>

<script>
  export default {
    name: 'TeamMoney',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      coinsOnHand: {
        get() {
          return this.sheet.params.coinsOnHand
        },
      },

      coinsOnTreasury: {
        get() {
          return this.sheet.params.coinsOnTreasury
        },
      },
    },

    methods: {
      fullBox(path, number) {
        return `circle ${this[path].current >= number ? 'select' : 'not-select'}`
      },

      changeCoins(path, isIncrement) {
        const value = this[path].current + (isIncrement ? 1 : -1)
        this.$store.commit('game/updateSheetParams',
                           {
                             id: this.sheet.id,
                             path: `${path}.current`,
                             value,
                           })

        this.saveSheet()
      },

      saveSheet() {
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'change',
          data: { ...this.sheet, type: 'sheet' },
        })
      },
    },
  }
</script>

<style scoped lang="scss">
  @import '~assets/css/colors';

  .base-money {
    width: 300px;
    margin-top: 10px;
  }

  .money-list {
    overflow: auto;
  }

  .black {
    background-color: $black;
    color: $white;
  }

  .inline {
    display: inline-block;
  }

  .on-hand-title {
    margin-right: 5px;
    padding: 5px;
  }

  .on-treasury-title {
    background-color: #fff;
    padding: 5px;
  }

  .circle {
    cursor: pointer;
    position: relative;
    top: 5px;
    width: 15px;
    height: 15px;
    border-radius: 50%;
    margin-right: 10px;
  }

  .on-hand {
    border: 3px solid $black;
    &.select {
      background: $black;
    }
  }

  .on-treasury {
    border: 3px solid $gray9E;
    &.select {
      background: $gray9E;
    }
  }

  .not-select {
    background: $white;
  }

  .separator {
    position: relative;
    top: 5px;
    width: 2px;
    height: 15px;
    margin-left: 2px;
    margin-right: 8px;
    background-color: black;
  }

  .text-help {
    font-size: 10px;
    font-style: italic;
  }
</style>
