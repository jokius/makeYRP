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
        @click="onSave"
      >
        <span class="whiteText">Изменить</span>
      </v-btn>
    </template>
  </draggable-dialog>
</template>

<script>
  import { mapState } from 'vuex'

  import DraggableDialog from './DraggableDialog'

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
      ...mapState({
        game: state => state.game.info,
        currentPage: state => state.game.currentPage,
      }),

      currentColor: {
        get() {
          return this.color
        },
        set(value) {
          this.color = value
          // this.$store.commit(CHANGE_TARGET_COLOR, { ...this.target, color: value })
        },
      },
    },

    methods: {
      onClose() {
        this.color = null
        this.save()
      },

      onSave() {
        this.save()
      },

      save() {
        this.$store.commit('game/removeOpenModal', this.uniqKey)
        switch (this.target.type) {
          case 'page':
          case 'grid':
            this.$store.commit('game/changePageColor', { id: this.target.id, type: this.target.type, color: this.color })
            break
          case 'borderColor':
            this.$store.commit('game/changeBorderColor', this.color)
            break
          case 'bodyColor':
            this.$store.commit('game/changeBodyColor', this.color)
            break
          default:
            break
        }
      },
    },
  }
</script>

<style scoped lang="scss">
  @import '~assets/css/colors';

  .whiteText {
    color: $white;
  }

  .page-modal-body {
    height: 300px;
  }
</style>
