<template>
  <div class="sheet-body">
    <div class="left-column">
      <team-talents :sheet="sheet" />
      <team-exp :sheet="sheet" />
      <team-relationship :sheet="sheet" />
      <team-improvements :sheet="sheet" />
      <special-places :sheet="sheet" />
    </div>
    <div class="right-column">
      <team-minions :sheet="sheet" />
      <team-den-improvements :sheet="sheet" />
    </div>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import TeamTalents from './TeamTalents'
  import TeamExp from './TeamExp'
  import TeamRelationship from './TeamRelationship'
  import TeamImprovements from './TeamImprovements'
  import SpecialPlaces from './SpecialPlaces'
  import TeamMinions from './TeamMinions'
  import TeamDenImprovements from './TeamDenImprovements'

  export default {
    name: 'TeamSkillBody',
    components: {
      TeamDenImprovements,
      TeamMinions,
      SpecialPlaces,
      TeamImprovements,
      TeamRelationship,
      TeamExp,
      TeamTalents,
    },
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
    },
  }
</script>

<style scoped lang="scss">
  @import '~assets/css/colors';

  .bgw {
    background: $white;
  }

  .sheet-body {
    display: grid;
    grid-template-columns: 600px 1fr;
    grid-template-rows: auto;
    grid-row-gap: 5px;
  }

  .left-column {
    display: grid;
    grid-template-columns: 1fr;
    grid-auto-rows: max-content;
    grid-row-gap: 5px;
  }

  .right-column {
    display: grid;
    grid-template-columns: 1fr;
    grid-auto-rows: max-content;
  }
</style>
