<template>
  <div class="specials-grid">
    <div
      v-for="(item, index) in special.items"
      :key="`special-${index}`"
      class="specials"
    >
      <v-text-field
        v-if="item.type === 'textField'"
        :value="item.value"
        :label="item.label"
        color="indigo"
        class="input name"
        flat
        hide-details
        @input="value => input(`specials[${specialIndex}].items[${index}].value`, value)"
        @change="saveSheet"
      />
      <div v-if="item.type === 'block-line'" class="block-line">
        <div
          v-for="(block, blockIndex) in item.items"
          :key="`special-${index}-block-${blockIndex}`"
          class="block"
        >
          <img
            v-if="block.itemType === 'icon'"
            :src="`/img/${block.path}`"
            class="icon"
            :title="block.label"
            :alt="block.label"
          />
          <div v-if="block.itemType === 'text'" class="text-black">{{ block.text }}</div>
          <v-text-field
            v-if="block.itemType === 'numberField'"
            :value="block.value"
            :label="block.label"
            color="indigo"
            class="input number"
            flat
            hide-details
            @input="value => input(`specials[${specialIndex}].items[${index}].value`, value)"
            @change="saveSheet"
          />
          <div v-if="block.itemType === 'description'" class="description" v-html="block.text" />
        </div>
      </div>
      <div v-if="item.type === 'description'" class="description" v-html="item.text" />
      <v-select
        v-if="item.type === 'select'"
        :items="item.list"
        :label="item.label"
        class="special-select"
        color="black"
        :multiple="item.multiple"
        :attach="item.multiple"
        :chips="item.multiple"
        :value="item.value"
        hide-details
        @change="value => selectSet(`specials[${specialIndex}].items[${index}].value`, value)"
      />
      <details v-if="item.type === 'block'" class="pointer">
        <summary class="black-title">{{ item.name }}</summary>
        <div class="blocks-grid">
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
                hide-details
                @change="value =>
                  selectSet(`specials[${specialIndex}].items[${index}].items[${blockIndex}].selects[${selectIndex}].value`,
                            value)"
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
              hide-details
              @change="value => selectSet(`specials[${specialIndex}].items[${index}].items[${blockIndex}].value`, value)"
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
      </details>
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
      input(path, value) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path,
                             value,
                           })
      },

      selectSet(path, value) {
        this.$store.commit(UPDATE_SHEET_PARAMS, { id: this.sheet.id, path, value })
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

  .pointer {
    cursor: pointer;
  }

  .specials-grid {
    background-color: $grayC5;
    overflow: auto;
    display: grid;
    grid-template-columns: 0.99fr;
    grid-template-rows: max-content;
    padding: 0 5px;
    min-height: 570px;
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

  .blocks-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    grid-column-gap: 15px;
  }

  .special-select {
    padding: 0;
    margin: 10px 0 10px;
    background-color: $white;
  }

  .block {
    margin-bottom: 15px;
  }

  .block-line {
    display: inline-flex;
  }

  .icon {
    width: 35px;
    height: 35px;
    margin-top: 10px;
  }

  .number {
    width: 70px;
    margin-left: 10px;
  }

  .text-black {
    margin-top: 17px;
    font-size: 20px;
  }
</style>
