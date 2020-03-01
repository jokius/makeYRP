<template>
  <div class="grid">
    <div :class="[{ selected }, 'button']" @click="cursor = 'rect'">
      <v-icon class="icon">mdi-brush</v-icon>
    </div>

    <div v-if="selected" class="drawing-item">
      <div :style="styleBorder" class="color-current" @click="openBorderColorSelect" />
      <div :style="styleBody" class="color-current" @click="openBodyColorSelect" />
      <v-select
        v-model="size"
        :items="sizes"
        color="indigo"
        class="select"
        flat
      />
    </div>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import { ADD_OPEN_MODAL, CHANGE_BORDER_SIZE, CHANGE_CURRENT_CURSOR } from '../../../stores/mutation-types'

  export default {
    name: 'DrawingButton',

    data() {
      return {
        sizes: [
          { text: 'Очень тонкие граници 1px', value: 1 },
          { text: 'Тонкие граници 2px', value: 2 },
          { text: 'Обычные граници 3px', value: 3 },
          { text: 'Широкие граници 4px', value: 4 },
          { text: 'Очень широкие граници 5px', value: 5 },
        ],
        targetBorder: { type: 'borderColor' },
        targetBody: { type: 'bodyColor' },
      }
    },

    computed: {
      ...mapState({
        currentCursor: state => state.game.currentCursor,
        borderSize: state => state.game.borderSize,
        borderColor: state => state.game.borderColor,
        bodyColor: state => state.game.bodyColor,
      }),

      cursor: {
        get() {
          return this.currentCursor
        },

        set(value) {
          this.$store.commit(CHANGE_CURRENT_CURSOR, value)
        },
      },

      selected: {
        get() {
          return this.cursor === 'rect'
        },
      },

      size: {
        get() {
          return this.borderSize
        },

        set(value) {
          this.$store.commit(CHANGE_BORDER_SIZE, value)
        },
      },

      styleBorder: {
        get() {
          const color = this.borderColor
          const rgb = `rgb(${color.r}, ${color.g}, ${color.b})`
          return {
            backgroundColor: rgb,
            backgroundImage: 'none',
          }
        },
      },

      styleBody: {
        get() {
          const color = this.bodyColor
          const rgba = `rgba(${color.r}, ${color.g}, ${color.b}, ${color.a})`
          return {
            backgroundImage: color.a > 0 ? 'none' : 'url("/img/transparent.png")',
            backgroundColor: rgba,
          }
        },
      },
    },

    methods: {
      openBorderColorSelect() {
        const key = Date.now()
        this.$store.commit(ADD_OPEN_MODAL, {
          key,
          name: 'color-picker',
          target: this.targetBorder,
          startColor: this.borderColor,
        })
      },

      openBodyColorSelect() {
        const key = Date.now()
        this.$store.commit(ADD_OPEN_MODAL, {
          key,
          name: 'color-picker',
          target: this.targetBody,
          startColor: this.bodyColor,
        })
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

  .selected {
    background-color: $indigoRGBA;
  }

  .drawing-item {
    display: inline-flex;
    position: absolute;
    z-index: 3;
    top: 0;
    left: 35px;
    border: $border;
    background-color: $white;
    width: max-content;
    padding: 5px;
  }

  .color-current {
    cursor: pointer;
    width: 33px;
    height: 33px;
    border:  1px solid $black;
    margin-right: 5px;
  }

  .select {
    margin: 0;
    padding: 0;
    width: 271px;
    height: 33px;
  }
</style>
