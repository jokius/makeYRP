<template>
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
                             path: `relationship`,
                             value: list,
                           })
      },

      saveSheet() {
        this.$store.dispatch('saveSheet', this.sheet)
      },
    },
  }
</script>
