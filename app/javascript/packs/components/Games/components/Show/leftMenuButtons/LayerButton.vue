<template>
  <v-speed-dial direction="right" open-on-hover>
    <template v-slot:activator>
      <div class="button">
        <v-icon class="icon">mdi-layers-outline</v-icon>
      </div>
    </template>
    <div class="grid-items">
      <button :class="[{ selected: layer === 'gm' }, 'item']" @click="layer = 'gm'">GM слой</button>
      <button :class="[{ selected: layer === 'map' }, 'item']" @click="layer = 'map'">Слой карты</button>
      <button :class="[{ selected: layer === 'players' }, 'item']" @click="layer = 'players'">Слой игроков</button>
    </div>
  </v-speed-dial>
</template>

<script>
  import { mapState } from 'vuex'

  import { CHANGE_CURRENT_LAYER } from '../../../stores/mutation-types'

  export default {
    name: 'LayerButton',

    computed: {
      ...mapState({
        currentLayer: state => state.game.currentLayer,
      }),

      layer: {
        get() {
          return this.currentLayer
        },

        set(value) {
          this.$store.commit(CHANGE_CURRENT_LAYER, value)
        },
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  $border: 1px solid $black;

  .button {
    width: 30px;
    height: 30px;
    background-color: $white;
    border: $border;
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
    border: $border;
    background-color: $white;
    .item:last-child {
      border-bottom: none;
    }
  }

  .item {
    padding: 5px;
    border-bottom: $border;

    &:hover {
      background-color: $indigoRGBA;
    }
  }

  .selected {
    background-color: $indigoRGBA;
  }
</style>
