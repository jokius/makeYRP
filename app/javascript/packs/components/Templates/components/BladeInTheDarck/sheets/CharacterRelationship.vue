<template>
  <div>
    <div class="black grid-title">
      <span class="title">друзья и недруги</span>
    </div>
    <div class="relationship-list">
      <div
        v-for="(relation, index) in relationship"
        :key="`relation-${index}`"
        class="relation"
      >
        <div class="respect">
          <div
            :class="`respect-base ${positiveClass(index)}`"
            @click="changeRespect(1, index)"
          />
          <div
            :class="`respect-base ${negativeClass(index)}`"
            @click="changeRespect(-1, index)"
          />
        </div>
        <v-text-field
          v-if="relation.editable"
          :value="relation.name"
          flat
          color="indigo"
          class="input"
          hide-details
          placeholder="Имя и описание"
          @input="(value) => inputName(value, index)"
          @change="saveSheet"
        />

        <p v-else v-html="`${relation.name} <i>${relation.description}</i>`" />
      </div>
    </div>
    <div class="actions">
      <v-btn
        class="button-add"
        rounded
        @click="addRelation"
      >
        Добавить отношение
      </v-btn>
    </div>
  </div>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'
  import { BiD } from '../../../../../lib/BiD'

  export default {
    name: 'CharacterRelationship',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      relationship: {
        get() {
          return this.sheet.params.relationship
        },
      },
    },

    methods: {
      positiveClass(index) {
        return this.respect(index) > 0 ? 'positive-active' : 'positive'
      },

      negativeClass(index) {
        return this.respect(index) < 0 ? 'negative-active' : 'negative'
      },

      inputName(value, index) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `relationship.${index}.name`,
                             value,
                           })
      },

      changeRespect(respect, index) {
        const value = this.respect(index) === respect ? 0 : respect

        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `relationship.${index}.respect`,
                             value,
                           })

        this.saveSheet()
      },

      addRelation() {
        const list = this.relationship.slice()
        list.push(BiD.getEmptyCharacterRelation)
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `relationship`,
                             value: list,
                           })
      },

      saveSheet() {
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'change',
          data: { ...this.sheet, type: 'sheet' },
        })
      },

      respect(index) {
        return this.relationship[index].respect
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .grid-title {
    margin-bottom: 5px;
  }

  .title {
    width: max-content;
    padding: 3px;
  }

  .black {
    background-color: $black;
    color: $white;
  }

  .relationship-list {
    display: grid;
    grid-template-columns: 1fr 1fr;
    grid-template-rows: auto;
  }

  .relation {
    display: flex;
  }

  .respect {
    display: flex;
    margin-top: 10px;
    margin-right: 5px;
    margin-left: 1px;
  }

  $triangle_size: 15px;
  $triangle_face: $triangle_size / 2;
  .respect-base {
    cursor: pointer;
    width: 0;
    height: 0;
    border-left: $triangle_face solid transparent;
    border-right: $triangle_face solid transparent;
  }

  .positive {
    border-bottom: $triangle_size solid $white;
  }

  .positive-active {
    border-bottom: $triangle_size solid $black;
  }

  .negative {
    border-top: $triangle_size solid $white;
  }

  .negative-active {
    border-top: $triangle_size solid $black;
  }

  .input {
    padding: 0;
    margin: 0 0 3px;
  }

  .actions {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 100%;
  }
</style>
