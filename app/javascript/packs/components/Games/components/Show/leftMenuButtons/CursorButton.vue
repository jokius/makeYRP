<template>
  <div :class="[{ selected: cursor === 'default' }, 'button']" @click="cursor = 'default'">
    <v-icon class="icon">mdi-cursor-default</v-icon>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import { CHANGE_CURRENT_CURSOR } from '../../../stores/mutation-types'

  export default {
    name: 'CursorButton',

    computed: {
      ...mapState({
        currentCursor: state => state.game.currentCursor,
      }),

      cursor: {
        get() {
          return this.currentCursor
        },

        set(value) {
          this.$store.commit(CHANGE_CURRENT_CURSOR, value)
        },
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .button {
    width: 30px;
    height: 30px;
    background-color: $white;
    border: 1px solid $black;
    border-bottom: none;
    cursor: pointer;
  }

  .icon {
    padding-left: 2px;
    padding-top: 2px;
  }

  .grid-items {
    display: grid;
    grid-template-columns: max-content;
    margin-top: 67px;
    margin-left: -17px;
    border: 1px solid $black;
    background-color: $white;
    .item:last-child {
      border-bottom: none;
    }
  }

  .selected {
    background-color: $indigoRGBA;
  }
</style>
