<template>
  <div class="headMenus">
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

  import PageTabsList from './PageTabsList'

  import {
    ADD_OPEN_MODAL,
  } from '../../stores/mutation-types'

  export default {
    name: 'HeadMenu',
    components: {  PageTabsList },
    computed: {
      ...mapState({
        openModals: state => state.game.openModals,
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
    display: grid;
    grid-template-columns: repeat(2, max-content);
    grid-gap: 5px;
    justify-content: right;
  }

  .plusButton {
    margin: 5px 5px 10px 3px;
  }
</style>
