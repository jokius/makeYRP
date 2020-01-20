<template>
  <draggable-dialog
    v-model="size"
    :on-close="onClose"
    title="Имя персонажа"
    :width="size.width"
    :height="size.height"
    resizable
  >
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
  import { DELETE_SHEET, REMOVE_OPEN_MODAL, UPDATE_SHEET } from '../../stores/mutation-types'

  export default {
    name: 'SheetModal',
    components: { MutantSheet, DraggableDialog },

    props: {
      uniqKey: { type: Number, required: true },
      id: { type: Number, required: true },
      sheetType: { type: String, required: true },
    },

    data() {
      return {
        privateWidth: null,
        privateHeight: null,
      }
    },

    channels: {
      SheetChannel: {
        received(obj) {
          if (obj.delete) {
            this.$cable.unsubscribe('SheetChannel')
            this.onClose()
            this.$store.commit(DELETE_SHEET, obj.delete)
          } else {
            this.$store.commit(UPDATE_SHEET, obj)
          }
        },
      },
    },

    computed: {
      ...mapState({
        game: state => state.game.info,
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
              return { width: this.privateWidth || 950, height: this.privateHeight || 600 }
            default:
              return { width: this.privateWidth || 950, height: this.privateHeight || 600 }
          }
        },

        set({ width, height }) {
          this.privateWidth = width
          this.privateHeight = height
        },
      },
    },

    mounted() {
      this.$cable.subscribe({
        channel: 'SheetChannel',
        sheet_id: this.id,
      })
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
