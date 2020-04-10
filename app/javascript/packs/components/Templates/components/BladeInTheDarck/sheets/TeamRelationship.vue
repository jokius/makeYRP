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
        <div class="enabled">
          <div
            :class="[{ enable: relation.enable }, 'enabled-base']"
            @click="changeEnable(!relation.enable, index)"
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

        <p v-else v-html="`${relation.name}, <i>${relation.type}</i>`" />
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
    name: 'TeamRelationship',
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
      inputName(value, index) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `relationship.${index}.name`,
                             value,
                           })
      },

      changeEnable(value, index) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `relationship.${index}.enable`,
                             value,
                           })

        this.saveSheet()
      },

      addRelation() {
        const list = this.relationship.slice()
        list.push(BiD.getEmptyTeamRelation)
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'relationship',
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

  .enabled {
    display: flex;
    margin-top: 3px;
    margin-right: 5px;
    margin-left: 1px;
  }

  $triangle_size: 15px;
  $triangle_face: $triangle_size / 2;
  .enabled-base {
    cursor: pointer;
    width: 0;
    height: 0;
    border-top: $triangle_face solid transparent;
    border-left: $triangle_size solid $white;
    border-bottom: $triangle_face solid transparent;
  }

  .enable {
    border-left: $triangle_size solid $black;
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

