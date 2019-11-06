<template>
  <div class="headMenus">
    <action-buttons />
    <page-tabs-list />
    <v-btn
      class="plusButton"
      color="indigo"
      fab
      dark
      small
      @click="addPageModal"
    >
      <v-icon dark>mdi-plus</v-icon>
    </v-btn>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import ActionButtons from '../../components/Show/ActionButtons'
  import PageTabsList from '../../components/Show/PageTabsList'
  import {
    ADD_OPEN_MODAL,
  } from '../../stores/mutation-types'

  export default {
    name: 'HeadMenu',
    components: { ActionButtons, PageTabsList },
    computed: {
      ...mapState({
        openModals: (state) => state.game.openModals,
      }),
    },
    methods: {
      addPageModal() {
        const key = Date.now()
        this.$store.commit(ADD_OPEN_MODAL, { name: 'page', key })
      },
    },
  }
</script>

<style scoped lang="scss">
  .headMenus {
    position: fixed;
    z-index: 1001;
    display: grid;
    grid-template-columns: repeat(3, max-content);
    grid-gap: 5px;
  }

  .plusButton {
    margin-left: 3px;
    margin-top: 5px;
  }
</style>
