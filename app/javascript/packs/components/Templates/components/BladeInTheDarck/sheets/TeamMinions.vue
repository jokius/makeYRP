<template>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'
  import { BiD } from '../../../../../lib/BiD'

  export default {
    name: 'TeamMinions',
    props: {
      sheet: { type: Object, required: true },
    },

    data() {
      return {
        types: [
          { text: 'шайка', value: 'gang' },
          { text: 'спец', value: 'specialist' },
        ],
      }
    },

    computed: {
      minions: {
        get() {
          return this.sheet.params.minions
        },
      },
    },

    methods: {
      inputName(value, index) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `minions.${index}.name`,
                             value,
                           })
      },

      changeState(value, index, state) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `minions.${index}.${state}`,
                             value,
                           })

        this.saveSheet()
      },

      addMinion() {
        const list = this.minions.slice()
        list.push(BiD.getEmptyMinion)
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `minions`,
                             value: list,
                           })
      },

      saveSheet() {
        this.$store.dispatch('saveSheet', this.sheet)
      },
    },
  }
</script>
