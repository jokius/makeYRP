<template>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'

  export default {
    name: 'SpecialPlaces',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      improvements: {
        get() {
          return this.sheet.params.specialPlaces
        },
      },
    },

    methods: {
      changeCurrent(value, index) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `specialPlaces.${index}.current`,
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
