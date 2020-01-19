<template>
  <div class="sheet-body">
    <appearance :sheet="sheet" />
    <goal :sheet="sheet" />
    <den :sheet="sheet" />
    <relationship :sheet="sheet" />
    <notes :sheet="sheet" />
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import Appearance from './Appearance'
  import Goal from './Goal'
  import Den from './Den'
  import Relationship from './Relationship'
  import Notes from './Notes'

  export default {
    name: 'CharacterInfo',
    components: { Notes, Relationship, Den, Goal, Appearance },
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
  .sheet-body {
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: auto;
    grid-row-gap: 5px;
  }
</style>
