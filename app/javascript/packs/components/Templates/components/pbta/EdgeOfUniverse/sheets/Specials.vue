<template>
  <div>
    <div
      v-for="(special, index) in specials"
      :key="`special-${index}`"
      class="specials"
    >
      <div
        v-for="(item, itemIndex) in specialsItems(special)"
        :key="`special-item-${itemIndex}`"
        class="specials"
      >
        <p class="special-title">{{ item.name }}</p>
        <p class="special-description">{{ item.description }}</p>
        <v-select
          v-if="item.type === 'select'"
          :items="item.list"
          class="special-select"
          color="black"
          :multiple="item.multiple"
          :attach="item.multiple"
          :chips="item.multiple"
          :value="item.value"
          @change="value => selectSet(index, itemIndex, value)"
        />
        <div v-if="item.type === 'moves'" class="moves">
          <specials-move
            v-for="(move, indexMove) in item.list"
            :key="`item-moves-${indexMove}`"
            :sheet="sheet"
            :move="move"
            :index="index"
            :item-index="itemIndex"
            :index-move="indexMove"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import SpecialsMove from './SpecialsMove'

  import { UPDATE_SHEET_PARAMS } from '../../../../../Games/stores/mutation-types'

  export default {
    name: 'Specials',
    components: { SpecialsMove },
    props: {
      id: { type: Number, required: true },
    },

    data() {
      return {
        modalOpen: false,
      }
    },

    computed: {
      ...mapState({
        sheets: state => state.game.sheets,
        tables: state => state.game.info.template.tables,
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
          return this.params.specials
        },
      },

      keys: {
        get() {
          return this.params.moves.map(item => item.key)
        },
      },
    },

    methods: {
      specialsItems(special) {
        console.log('special', special)
        return special.filter(item => !item.key || this.keys.includes(item.key))
      },

      selectSet(index, selectIndex, value) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `specials[${index}][${selectIndex}].value`,
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
  @import 'app/javascript/packs/components/ui/css/colors';

  .black {
    background-color: $black;
    color: $white;
    text-align: center;
  }

  .specials {
    margin-top: 10px;
    margin-left: 5px;
    margin-right: 5px;
    width: 99%;
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
</style>
