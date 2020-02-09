<template>
  <div class="grid">
    <v-overflow-btn
      class="selectButton"
      :items="items"
      label="Создать персонажа"
      color="indigo"
      segmented
      item-color="indigo"
      @change="value => $store.dispatch('createSheet', value)"
    />
    <sheets-list />
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import SheetsList from '../../components/Show/SheetsList'

  export default {
    name: 'TabSheets',
    components: { SheetsList },

    computed: {
      ...mapState({
        sheetTypes: state => state.game.info.sheetTypes,
      }),

      items() {
        return this.sheetTypes.map(type => ({
          text: type.text,
          value: type.value,
          callback: () => this.$store.dispatch('createSheet', type.value),
        }))
      },
    },
  }
</script>

<style scoped lang="scss">
  .grid {
    display: grid;
    grid-template-columns: 1fr;
    grid-auto-rows: auto;
    grid-row-gap: 5px;
  }
  .selectButton {
    margin: 0;
    width: auto;
  }
</style>
