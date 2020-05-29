<template>
  <div class="relationship-body">
    <div
      v-for="(relation, index) in relationship"
      :key="`relation-${index}`"
      class="relation"
    >
      <span class="index">{{ index + 1 }}.</span>
      <span class="relation-first">{{ relation.first }}</span>
      <v-text-field
        :value="relation.value"
        color="indigo"
        class="relation-name"
        flat
        @input="(value) => changeRelation(value, index)"
        @change="saveSheet"
      />
      <span class="relation-last">{{ relation.last }}</span>
    </div>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  export default {
    name: 'CharacterRelationshipBody',
    props: {
      id: { type: Number, required: true },
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

      relationship: {
        get() {
          return this.sheet.params.relationship
        },
      },
    },

    methods: {
      changeRelation(value, index) {
        this.$store.commit('game/updateSheetParams',
                           {
                             id: this.sheet.id,
                             path: `relationship.${index}.value`,
                             value,
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
  @import '~assets/css/colors';

  .relationship-body {
    background-color: $grayC5;
    overflow: auto;
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: max-content;
    padding: 0 5px;
    height: 570px;
  }

  .relation {
    display: grid;
    grid-template-columns: max-content max-content 150px max-content;
    grid-column-gap: 5px;
  }

  .relation-name {
    margin-top: -5px;
    padding: 0;
  }
</style>
