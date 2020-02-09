<template>
  <div class="sheet-body">
    <projects-grid :sheet="sheet" :projects="sheet.params.prisonProjects" projects-key="prisonProjects" />
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import ProjectsGrid from './ProjectsGrid'

  export default {
    name: 'PrisonBody',
    components: { ProjectsGrid },
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
    justify-content: center;
    margin-top: 10px;
  }
</style>
