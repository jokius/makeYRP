<template>
  <draggable-dialog :on-close="onClose" title="Имя персонажа" :width="size.width" :height="size.height">
    <template v-slot:body>
      <mutant-sheet v-if="sheet === 'mutant_year_zero-mutant'" :id="id" :key="key" :size="size" />
      <v-alert
        v-else
        :key="key"
        v-model="alert"
        dismissible
        class="alert"
        type="error"
      >
        {{ sheet }} не существует
      </v-alert>
      <div />
    </template>
  </draggable-dialog>
</template>

<script>
  import { mapState } from 'vuex'

  import DraggableDialog from './DraggableDialog'

  import MutantSheet from '../../../Templates/components/MYZ/sheets/MutantSheet'
  import { REMOVE_OPEN_MODAL } from '../../stores/mutation-types'

  export default {
    name: 'SheetModal',
    components: { MutantSheet, DraggableDialog },
    props: {
      uniqKey: { type: Number, required: true },
      id: { type: Number, required: true },
      sheetType: { type: String, required: true },
    },

    computed: {
      ...mapState({
        game: (state) => state.game.info,
      }),

      sheet: {
        get() {
          return `${this.game.system}-${this.sheetType}`
        },
      },

      key: {
        get() {
          return `${this.sheet}-${this.id}`
        },
      },

      size: {
        get() {
          switch (this.sheet) {
            case 'mutant_year_zero-mutant':
              return { width: 950, height: 600 }
            default:
              return { width: 950, height: 700 }
          }
        },
      },
    },
    methods: {
      onClose() {
        this.$store.commit(REMOVE_OPEN_MODAL, this.uniqKey)
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .whiteText {
    color: $white;
  }
</style>
