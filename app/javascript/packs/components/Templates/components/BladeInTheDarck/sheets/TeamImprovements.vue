<template>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'
  import { BiD } from '../../../../../lib/BiD'

  export default {
    name: 'TeamImprovements',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      improvements: {
        get() {
          return this.sheet.params.teamImprovements
        },
      },
    },

    methods: {
      inputName(value, index) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `teamImprovements.${index}.name`,
                             value,
                           })
      },

      changeCurrent(value, index) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `teamImprovements.${index}.current`,
                             value,
                           })

        this.saveSheet()
      },

      addImprovements() {
        const list = this.teamImprovements.slice()
        list.push(BiD.getEmptyTeamImprovements)
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `teamImprovements`,
                             value: list,
                           })
      },

      saveSheet() {
        this.$store.dispatch('saveSheet', this.sheet)
      },
    },
  }
</script>
