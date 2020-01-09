<template>
  <div class="sheet-body">
    <div class="left-column">
      <talents :sheet="sheet" />
      <character-relationship :sheet="sheet" />
    </div>
    <div class="right-column">
      <character-money :sheet="sheet" />
      <attributes :sheet="sheet" />
      <things-and-gear :sheet="sheet" />
    </div>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import Talents from './Talents'
  import CharacterRelationship from './CharacterRelationship'
  import CharacterMoney from './CharacterMoney'
  import Attributes from './Attributes'
  import ThingsAndGear from './ThingsAndGear'

  export default {
    name: 'SkillBody',
    components: { ThingsAndGear, Attributes, CharacterMoney, CharacterRelationship, Talents },
    props: {
      id: { type: Number, required: true },
    },

    computed: {
      ...mapState({
        sheets: (state) => state.game.sheets,
      }),

      sheet: {
        get() {
          return this.sheets.find((sheet) => sheet.id === this.id)
        },
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .bgw {
    background: $white;
  }

  .sheet-body {
    display: grid;
    grid-template-columns: 600px 1fr;
    grid-template-rows: auto;
    grid-row-gap: 5px;
    grid-column-gap: 15px;
  }

  .left-column {
    display: grid;
    grid-template-columns: 1fr;
    grid-auto-rows: max-content;
  }

  .right-column {
    display: grid;
    grid-template-columns: 1fr;
    grid-auto-rows: max-content;
  }
</style>
