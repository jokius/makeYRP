<template>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'

  export default {
    name: 'TeamDenImprovements',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      denImprovements: {
        get() {
          return this.sheet.params.denImprovements
        },
      },
    },

    methods: {
      changeCurrent(value, indexImprovements, index) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `denImprovements[${indexImprovements}.improvements[${index}].current`,
                             value,
                           })

        this.saveSheet()
      },

      saveSheet() {
        this.$store.dispatch('saveSheet', this.sheet)
      },
    },
  }
</script>
