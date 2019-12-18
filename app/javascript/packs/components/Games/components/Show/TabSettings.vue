<template>
  <div class="grid">
    <v-btn
      class="bg-button"
      :style="style"
      outlined
      @click="openSelect = true"
    >
      <span v-if="!background.image" class="bg-text">Нажмите что бы выбрать фон</span>
      <v-img
        v-else
        :src="background.image.versions.thumb"
        :lazy-src="background.image.versions.lazy"
        aspect-ratio="1"
        position="center"
        class="bg-image"
        max-width="292px"
        max-height="192px"
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

    <div class="grid-sub">
      <span class="color-text">Цвет фона</span>
      <div :style="style" class="color-current" @click="openColorSelect" />
      <span class="grid-select-text">Ширина доски</span>
      <v-text-field
        v-model.number="boardWidth"
        required
        color="indigo"
        class="grid-size"
        type="number"
      />
      <span class="grid-select-text">Высота доски</span>
      <v-text-field
        v-model.number="boardHeight"
        required
        color="indigo"
        class="grid-size"
        type="number"
      />
      <span class="grid-select-text">Тип сетки</span>
      <v-select
        v-model="grid"
        :items="gridItems"
        class="grid-select"
      />
      <v-text-field
        v-if="grid"
        v-model.number="gridWidth"
        required
        color="indigo"
        label="Ширина клетки"
        class="grid-size"
        type="number"
      />
      <v-text-field
        v-if="grid"
        v-model.number="gridHeight"
        required
        color="indigo"
        label="Высота клетки"
        class="grid-size"
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
            target: 'page',
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

      gridWidth: {
        get() {
          return this.params.gridWidth || 70
        },

        set(value) {
          this.$store.dispatch('changePage', { gridWidth: value })
        },
      },

      gridHeight: {
        get() {
          return this.params.gridHeight || 70
        },

        set(value) {
          this.$store.dispatch('changePage', { gridHeight: value })
        },
      },

      boardWidth: {
        get() {
          return this.params.width || 800
        },

        set(value) {
          this.$store.dispatch('changePage', { width: value })
        },
      },

      boardHeight: {
        get() {
          return this.params.height || 600
        },

        set(value) {
          this.$store.dispatch('changePage', { height: value })
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

  $color_height: 25px;
  $grid_select_height: 60px;

  .grid {
    display: grid;
    grid-template-columns: 1fr;
    grid-auto-rows: auto;
    grid-row-gap: 5px;
    margin: 5px 10px 5px 5px;
    color: $black;
  }

  .grid-sub {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    grid-column-gap: 1px;
    grid-auto-rows: auto;
    grid-row-gap: 10px;
  }

  .bg-button.v-size--default {
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

  .bg-image {
    position: relative;
    width: 300px;
    height: 200px;
  }

  .bg-text {
    position: relative;
    z-index: 2;
    background-color: #fff3;
  }

  .color-current {
    justify-self: end;
    cursor: pointer;
    width: 50px;
    height: $color_height;
    border:  1px solid $black;
  }

  .color-text {
    vertical-align: middle;
    line-height: $color_height;
  }

  .grid-select {
    justify-self: end;
    height: $grid_select_height;
  }

  .grid-select-text {
    vertical-align: middle;
    line-height: $grid_select_height;
  }

  .grid-size {
    width: 120px;
    justify-self: end;
    &::after {
      content: 'px';
    }
  }
</style>
