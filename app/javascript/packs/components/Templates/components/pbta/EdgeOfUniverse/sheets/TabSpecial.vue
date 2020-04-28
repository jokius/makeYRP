<template>
  <div class="specials-grid">
    <div
      v-for="(item, index) in special.items"
      :key="`special-${index}`"
      class="specials"
    >
      <div v-if="item.type === 'block'" class="blocks">
        <div class="black-title">{{ item.name }}</div>
        <div
          v-for="(block, blockIndex) in item.items"
          :key="`special-${index}-block-${blockIndex}`"
          class="block"
        >
          <div v-if="block.itemType === 'selects'" class="selects">
            <v-select
              v-for="(select, selectIndex) in block.selects"
              :key="`${index}-${selectIndex}-selects`"
              :items="select.list"
              :label="select.label"
              class="special-select"
              color="black"
              :multiple="select.multiple"
              :attach="select.multiple"
              :chips="select.multiple"
              :value="select.value"
              @change="value => selectSet(`[${index}][${selectIndex}]`, value)"
            />
          </div>

          <v-select
            v-if="block.itemType === 'select'"
            :items="block.list"
            :label="block.label"
            class="special-select"
            color="black"
            :multiple="block.multiple"
            :attach="block.multiple"
            :chips="block.multiple"
            :value="block.value"
            @change="value => selectSet(`[${index}]`, value)"
          />

          <move
            v-else-if="block.itemType === 'move'"
            :sheet="sheet"
            :move="block"
            :index="blockIndex"
            :path="`specials[${specialIndex}].items[${index}].items`"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import Move from './Move'

  import { UPDATE_SHEET_PARAMS } from '../../../../../Games/stores/mutation-types'

  export default {
    name: 'TabSpecial',
    components: { Move },
    props: {
      id: { type: Number, required: true },
      specialIndex: { type: Number, required: true },
      special: { type: Object, required: true },
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
    },

    methods: {
      selectSet(path, value) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `specials${path}.value`,
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

  .specials-grid {
    background-color: $grayC5;
    overflow: auto;
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: max-content;
    padding: 0 5px;
    height: 570px;
  }

  .black-title {
    margin-top: 5px;
    margin-bottom: 5px;
    font-size: 20px;
    font-weight: bold;
    text-align: center;
  }

  .black {
    background-color: $black;
    color: $white;
    text-align: center;
  }

  .special-select {
    margin: 0;
    padding: 0;
  }

  .block {
    margin-bottom: 15px;
  }
</style>
