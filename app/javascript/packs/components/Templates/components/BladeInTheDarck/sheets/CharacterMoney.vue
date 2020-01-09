<template>
  <div class="money-list">
    <div class="col1">
      <p class="stash-title">заначка</p>
      <p class="on-hand-title"><b>монеты</b></p>
      <div class="on-hand">
        <div
          v-for="number in 4"
          :key="`coins-${number}`"
          :class="fullBox('coins', number)"
          @click="changeCoins('coins', coins < number)"
        />
      </div>
    </div>
    <div class="stash">
      <div
        v-for="number in 40"
        :key="`stash-${number}`"
        :class="fullBox('stash', number)"
        @click="changeCoins('stash', stash < number)"
      />
    </div>
  </div>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'

  export default {
    name: 'CharacterMoney',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      coins: {
        get() {
          return this.sheet.params.coins
        },
      },

      stash: {
        get() {
          return this.sheet.params.stash
        },
      },
    },

    methods: {
      fullBox(path, number) {
        return `circle ${this[path] >= number ? 'select' : 'not-select'}`
      },

      changeCoins(path, isIncrement) {
        const value = this[path] + (isIncrement ? 1 : -1)
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path,
                             value,
                           })

        this.saveSheet()
      },

      saveSheet() {
        this.$store.dispatch('saveSheet', this.sheet)
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  p {
    margin: 0;
  }

  .money-list {
    display: grid;
    grid-template-columns: max-content 1fr;
  }

  .on-hand-title {
    margin-top: 13px;
  }

  .on-hand {
    display: grid;
    grid-template-columns: repeat(2, 25px);
    grid-auto-rows: 25px;
    margin-left: 10px;
  }

  .stash {
    display: grid;
    grid-template-columns: repeat(10, 25px);
    grid-auto-rows: 25px;
    margin-left: 10px;
    margin-top: 5px;
  }

  .circle {
    cursor: pointer;
    background-color: #FFFFFF;
    width: 50%;
    height: 50%;
    border-radius: 50%;
    border: 1px solid $black;
  }

  .select {
    background: $black;
  }

  .not-select {
    background: $white;
  }
</style>
