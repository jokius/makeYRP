<template>
  <div class="grid">
    <v-btn
      class="bgButton"
      :style="style"
      outlined
      @click="openSelect = true"
    >
      <span v-if="!background.image" class="bgText">Нажмите что бы выбрать фон</span>
      <v-img
        v-else
        :src="background.image.versions.thumb"
        :lazy-src="background.image.versions.lazy"
        aspect-ratio="1"
        position="center"
        class="bgImage"
      >
        <template v-slot:placeholder>
          <v-row
            class="fill-height ma-0"
            align="center"
            justify="center"
          >
            <v-progress-circular indeterminate color="grey lighten-5" />
          </v-row>
        </template>
      </v-img>
    </v-btn>

    <div class="subGrid">
      <span class="colorText">Цвет фона</span>
      <div :style="style" class="currentColor" @click="openColorSelect" />
      <span class="gridSelectText">Тип сетки</span>
      <v-select
        v-model="grid"
        :items="gridItems"
        class="gridSelect"
      />
      <v-text-field
        v-if="grid"
        v-model="gridWith"
        required
        color="indigo"
        label="Ширина клетки"
        class="gridSize"
        type="number"
      />
      <v-text-field
        v-if="grid"
        v-model="gridHeight"
        required
        color="indigo"
        label="Высота клетки"
        class="gridSize gridHeight"
        type="number"
      />
    </div>

    <folders-modal
      v-if="openSelect"
      :target-obj="targetPage"
      :open-dialog="openSelect"
      @close="openSelect = false"
    />
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import FoldersModal from './folders/FoldersModal'

  import { ADD_OPEN_MODAL } from '../../stores/mutation-types'

  export default {
    name: 'TabSettings',
    components: { FoldersModal },
    data() {
      return {
        openSelect: false,
        gridItems: [
          { text: 'Нет', value: null },
          { text: 'Клетки', value: 'cell' },
          { text: 'Гексы', value: 'hex' },
        ],
      }
    },

    computed: {
      ...mapState({
        game: (state) => state.game.info,
        currentPage: (state) => state.game.currentPage,
      }),

      params: {
        get() {
          return this.currentPage.params
        },
      },

      targetPage: {
        get() {
          return {
            target: 'pageBackground',
            params: {
              game_id: this.game.id,
              id: this.currentPage.id,
              name: this.currentPage.name,
            },
          }
        },
      },

      background: {
        get() {
          return this.params.background
        },
      },

      style: {
        get() {
          return {
            backgroundColor: this.background.color,
          }
        },
      },

      grid: {
        get() {
          return this.params.grid || null
        },

        set(value) {
          this.$store.dispatch('changePage', { grid: value })
        },
      },

      gridWith: {
        get() {
          return this.params.gridWith || 70
        },

        set(value) {
          this.$store.dispatch('changePage', { gridWith: value })
        },
      },

      gridHeight: {
        get() {
          return this.params.gridWith || 70
        },

        set(value) {
          this.$store.dispatch('changePage', { gridHeight: value })
        },
      },
    },

    methods: {
      openColorSelect() {
        const key = Date.now()
        this.$store.commit(ADD_OPEN_MODAL, {
          key,
          name: 'color-picker',
          target: this.targetPage,
          startColor: this.background.color,
        })
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .grid {
    display: grid;
    grid-template-columns: 1fr;
    grid-auto-rows: auto;
    grid-row-gap: 5px;
    margin: 5px 10px 5px 5px;
    color: $black;
  }

  .subGrid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    grid-column-gap: 1px;
    grid-auto-rows: auto;
    grid-row-gap: 10px;
  }

  .bgButton.v-size--default {
    height: 200px;
    border-width: 2px;
    border-radius: 2px;
    border-color: #b3b3b3;
    border-style: dashed;
    transition: border .24s ease-in-out;
    position: relative;
    &:hover {
      background-color: $purple51 !important;
    }
  }

  .bgImage {
    position: fixed;
    width: 300px;
    height: 200px;
  }

  .bgText {
    position: fixed;
    z-index: 2;
    background-color: #fff3;
  }

  $color_height: 25px;

  .currentColor {
    justify-self: end;
    cursor: pointer;
    width: 50px;
    height: $color_height;
    border:  1px solid $black;
  }

  .colorText {
    vertical-align: middle;
    line-height: $color_height;
  }

  $grid_select_height: 60px;

  .gridSelect {
    justify-self: end;
    height: $grid_select_height;
  }

  .gridSelectText {
    vertical-align: middle;
    line-height: $grid_select_height;
  }

  .gridSize {
    width: 120px;
    &::after {
      content: 'px';
    }
  }

  .gridHeight {
    justify-self: end;
  }
</style>
