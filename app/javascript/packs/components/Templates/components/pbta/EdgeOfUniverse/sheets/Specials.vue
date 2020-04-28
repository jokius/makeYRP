<template>
  <div class="specials">
    <div
      v-for="(special, index) in specials"
      :key="`special-${index}`"
      class="special"
    >
      <p class="special-title">{{ special.name }}</p>
      <p class="special-description">{{ special.description }}</p>
      <div v-if="special.type === 'select'" class="select">
        <v-select
          :items="special.list"
          class="special-select"
          color="black"
          :multiple="special.multiple"
          :attach="special.multiple"
          :chips="special.multiple"
          :value="special.value"
          @change="value => selectSet(index, value)"
        />

        <div v-for="(description, selectIndex) in selectDescriptions(special.value)" :key="`description-${selectIndex}`">
          <div v-html="description" />
        </div>
      </div>
      <p v-if="special.value && special.value.description" class="special-description">
        {{ special.value.description }}
      </p>
      <div v-if="special.type === 'moves'" class="moves">
        <move
          v-for="(move, indexMove) in special.list"
          :key="`special-moves-${indexMove}`"
          :sheet="sheet"
          :move="move"
          :index="indexMove"
          :path="`specials[${index}].list`"
        />
      </div>
      <div v-if="special.type === 'counter'" class="counter">
        <div
          v-for="number in special.max"
          :key="`counter-${index}-${number}`"
          class="box-line"
          @click="boxSet(index, number, special.max)"
        >
          <div :class="[{ enable: special.current >= number }, 'box']" />
        </div>
      </div>
      <div v-if="special.type === 'description'" class="description">
        {{ special.text }}
      </div>
    </div>
  </div>
</template>

<script>
  import { mapState } from 'vuex'
  import { get } from 'lodash'

  import Move from './Move'

  import { UPDATE_SHEET_PARAMS } from '../../../../../Games/stores/mutation-types'

  export default {
    name: 'Specials',
    components: { Move },
    props: {
      id: { type: Number, required: true },
    },

    data() {
      return {
        modalOpen: false,
        types: ['select', 'moves', 'counter', 'description'],
      }
    },

    computed: {
      ...mapState({
        sheets: state => state.game.sheets,
      }),

      sheet: {
        get() {
          return this.sheets.find(sheet => sheet.id === this.id)
        },
      },

      params: {
        get() {
          return this.sheet.params
        },
      },

      specials: {
        get() {
          return this.params.specials.filter(item =>
            this.types.includes(item.type) && (!item.key || this.keys.includes(item.key))
          )
        },
      },

      keys: {
        get() {
          return this.params.moves.map(item => item.key)
        },
      },
    },

    methods: {
      selectDescriptions(values) {
        if (Array.isArray(values)) return values

        return [values]
      },

      selectSet(index, value) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `specials[${index}].value`,
                             value,
                           })

        this.saveSheet()
      },

      boxSet(index, number, max) {
        const current = get(this.params, `specials[${index}].current`)
        let value = current < max ? number : 0
        value = number === current && number === 1 ? 0 : number
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `specials[${index}].current`,
                             value: value,
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
  @import 'app/javascript/packs/components/ui/css/colors';

  .black {
    background-color: $black;
    color: $white;
    text-align: center;
  }

  .specials {
    margin: 10px 5px 15px;
  }

  .special-title {
    font-weight: bold;
    font-size: 15px;
    margin: 0;
  }

  .special-select {
    margin: 0;
    padding: 0;
  }

  .counter {
    margin-left: -5px;
  }

  .box-line {
    display: inline-flex;
  }

  .box {
    position: relative;
    bottom: 8px;
    cursor: pointer;
    width: 20px;
    height: 20px;
    margin-left: 5px;
    border: 2px solid $black;
    background-color: $white;
  }

  .enable {
    background-color: $black;
  }
</style>
