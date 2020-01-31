<template>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'
  import { BiD } from '../../../../../lib/BiD'

  export default {
    name: 'TeamExp',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      exp: {
        get() {
          return this.sheet.params.exp
        },
      },

      currentExp: {
        get() {
          return this.exp.current
        },
      },
    },

    methods: {
      colorClass(number) {
        return this.currentExp >= number ? 'full-gray' : 'full-white'
      },

      changeExp(isIncrement) {
        const value = this.currentExp + (isIncrement ? 1 : -1)
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'exp.current',
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
