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

  import PageModal from '../../components/Show/PageModal'

  export default {
    name: 'OpenModals',
    components: { ColorPickerModal, PageModal },
    data () {
      return {
        alert: true,
      }
    },
    computed: {
      ...mapState({
        openModals: (state) => state.game.openModals,
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
