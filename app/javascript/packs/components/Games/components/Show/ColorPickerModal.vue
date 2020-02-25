<template>
  <draggable-dialog
    :on-close="onClose"
    title="Выбор цвета"
    :width="325"
    :height="400"
    :size="{}"
  >
    <template v-slot:body>
      <v-container class="fill-height page-modal-body" fluid>
        <v-color-picker
          v-model="currentColor"
          flat
        />
      </v-container>
    </template>
    <template v-slot:actions>
      <v-btn
        dark
        color="indigo"
        @click="onClose"
      >
        Закарыть
      </v-btn>
      <v-spacer />
      <v-btn
        color="indigo"
        @click="save"
      >
        <span class="whiteText">Изменить</span>
      </v-btn>
    </template>
  </draggable-dialog>
</template>

<script>
  import DraggableDialog from './DraggableDialog'

  import { CHANGE_TARGET_COLOR, REMOVE_OPEN_MODAL } from '../../stores/mutation-types'

  export default {
    name: 'ColorPickerModal',
    components: { DraggableDialog },

    props: {
      uniqKey: { type: Number, required: true },
      target: { type: Object, required: true },
      startColor: { type: Object, default: () => ({}) },
    },

    data() {
      return {
        color: this.startColor.hex ? this.startColor.hex : this.startColor,
      }
    },

    computed: {
      currentColor: {
        get() {
          return this.color
        },
        set(value) {
          this.color = value
          this.$store.commit(CHANGE_TARGET_COLOR, { ...this.target, color: value })
        },
      },
    },

    methods: {
      onClose() {
        this.$store.commit(REMOVE_OPEN_MODAL, this.uniqKey)
      },

      save() {
        this.$store.commit(REMOVE_OPEN_MODAL, this.uniqKey)
        this.$store.dispatch('saveTargetColor', { ...this.target, color: this.color })
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .whiteText {
    color: $white;
  }

  .page-modal-body {
    height: 300px;
  }
</style>
