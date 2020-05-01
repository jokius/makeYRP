<template>
  <div class="main-body">
    <div class="main-row1">
      <div class="main-row1-col1">
        <avatar :sheet="sheet" />
      </div>
      <div class="main-row1-col2">
        <div class="main-row1-col2-base-info">
          <span class="name">{{ name }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import Avatar from './Avatar'

  export default {
    name: 'CharacterReadOnly',
    components: { Avatar },

    props: {
      id: { type: Number, required: true },
    },

    data() {
      return {
        modalOpen: false,
        modalModifierOpen: false,
        currentState: {},
      }
    },

    computed: {
      ...mapState({
        sheets: state => state.game.sheets,
      }),

      sheet: {
        get() {
          return this.sheets.find(sheet => sheet.id === this.id)
        },
      },

      name: {
        get() {
          return this.sheet.name
        },
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .main-body {
    background-color: $grayC5;
    overflow: auto;
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: repeat(2, max-content);
    grid-row-gap: 5px;
  }

  .main-row1 {
    display: grid;
    grid-template-columns: 200px 0.99fr;
    grid-template-rows: max-content;
    grid-column-gap: 10px;
  }

  .name {
    margin-top: 10px;
  }
</style>
