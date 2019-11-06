<template>
  <div>
    <template v-for="modal in openModals">
      <page-modal v-if="modal.name === 'page'" :key="modal.key" :uniq-key="modal.key" />
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

  import PageModal from '../../components/Show/PageModal'

  export default {
    name: 'OpenModals',
    components: { PageModal },
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
