<template>
  <div>
    <template v-for="modal in openModals">
      <page-modal v-if="modal.name === 'page'" :key="`page_${modal.key}`" :uniq-key="modal.key" />
      <color-picker-modal
        v-else-if="modal.name === 'color-picker'"
        :key="`color-picker_${modal.key}`"
        :uniq-key="modal.key"
        :target="modal.target"
        :start-color="modal.startColor"
      />
      <sheet-modal
        v-else-if="modal.name === 'sheet'"
        :id="modal.id"
        :key="`sheet_${modal.key}`"
        :uniq-key="modal.key"
        :sheet-type="modal.sheetType"
      />
      <info-modal
        v-else-if="modal.name === 'info'"
        :id="modal.id"
        :key="`info_${modal.key}`"
        :uniq-key="modal.key"
        :title="modal.title"
        :description="modal.description"
      />
      <note-modal
        v-else-if="modal.name === 'note'"
        :key="`note_${modal.key}`"
        :uniq-key="modal.key"
        :is-edit="modal.isEdit"
        :is-new="modal.isNew"
        :note="modal.note"
      />
      <planet-modal
        v-else-if="modal.name === 'planet'"
        :key="`planet_${modal.key}`"
        :uniq-key="modal.key"
        :is-edit="modal.isEdit"
        :is-new="modal.isNew"
        :planet="modal.planet"
      />
      <v-alert
        v-else
        :key="modal.key"
        v-model="alert"
        dismissible
        class="alert"
        type="error"
      >
        {{ modal.name }} не существует
      </v-alert>
    </template>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import ColorPickerModal from './ColorPickerModal'
  import SheetModal from './SheetModal'
  import InfoModal from './InfoModal'
  import NoteModal from './NoteModal'
  import PageModal from './PageModal'

  import PlanetModal from '../../templates/pbta/EdgeOfUniverse/modals/PlanetModal'

  export default {
    name: 'OpenModals',
    components: { PlanetModal, NoteModal, InfoModal, SheetModal, ColorPickerModal, PageModal },
    data () {
      return {
        alert: true,
      }
    },
    computed: {
      ...mapState({
        openModals: state => state.game.openModals,
      }),
    },
  }
</script>

<style scoped lang="scss">
  .alert {
    width: 100vw;
    position: absolute;
    z-index: 999999;
  }
</style>
