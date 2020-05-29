<template>
  <div class="grid">
    <v-btn
      class="bg-button"
      :style="stylePage"
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
      <div :style="stylePage" class="color-current" @click="openPageColorSelect" />
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
        v-model="gridType"
        :items="gridItems"
        class="grid-select"
      />
      <v-text-field
        v-if="gridType"
        v-model.number="gridWidth"
        required
        color="indigo"
        label="Ширина клетки"
        class="grid-size"
        type="number"
      />
      <v-text-field
        v-if="gridType"
        v-model.number="gridHeight"
        required
        color="indigo"
        label="Высота клетки"
        class="grid-size"
        type="number"
      />
      <span v-if="gridType" class="color-text">Цвет сетки</span>
      <div v-if="gridType" :style="styleGrid" class="color-current" @click="openGridColorSelect" />

      <v-btn
        class="selectButton"
        color="indigo"
        tile
        dark
        @click="changePage"
      >
        Сохранить
      </v-btn>
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
  import { get } from 'lodash'

  import FoldersModal from './folders/FoldersModal'

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

        privateParams: {
          grid: {
            type: null,
            width: null,
            height: null,
            color: null,
          },
          background: {
            color: null,
          },

          width: null,
          height: null,
        },
      }
    },

    computed: {
      ...mapState({
        game: state => state.game.info,
        currentPage: state => state.game.currentPage,
        pageColor: state => state.game.pageColor,
      }),

      params: {
        get() {
          return this.currentPage.params
        },
      },

      targetPage: {
        get() {
          return {
            type: 'page',
            id: this.currentPage.id,
            target: 'page',
          }
        },
      },

      targetGrid: {
        get() {
          return {
            type: 'grid',
            id: this.currentPage.id,
          }
        },
      },

      background: {
        get() {
          return this.params.background
        },
      },

      privatePageColor: {
        get() {
          return get(this.pageColor, `${this.currentPage.id}.page.color`, null)
        },
      },

      backgroundColor: {
        get() {
          return this.privatePageColor || this.background.color
        }
      },

      stylePage: {
        get() {
          return {
            backgroundColor: this.backgroundColor,
          }
        },
      },

      grid: {
        get() {
          return this.params.grid
        },
      },

      privateGridColor: {
        get() {
          return get(this.pageColor, `${this.currentPage.id}.grid.color`, null)
        },
      },

      gridColor: {
        get() {
          return this.privateGridColor || this.grid.color
        }
      },

      styleGrid: {
        get() {
          const color = this.gridColor
          const rgba = `rgba(${color.r}, ${color.g}, ${color.b}, ${color.a})`
          return {
            backgroundColor: rgba,
          }
        },
      },

      gridType: {
        get() {
          return this.privateParams.grid.type || this.params.grid.type || null
        },

        set(value) {
          this.privateParams.grid.type = value
        },
      },

      gridWidth: {
        get() {
          return this.privateParams.grid.width || this.params.grid.width
        },

        set(value) {
          this.privateParams.grid.width = value
        },
      },

      gridHeight: {
        get() {
          return this.privateParams.grid.height || this.params.grid.height
        },

        set(value) {
          this.privateParams.grid.height = value
        },
      },

      boardWidth: {
        get() {
          return this.privateParams.width || this.params.width
        },

        set(value) {
          this.privateParams.width = value
        },
      },

      boardHeight: {
        get() {
          return this.privateParams.height || this.params.height
        },

        set(value) {
          this.privateParams.height = value
        },
      },

      pageParams: {
        get() {
          return {
            grid: {
              type: this.gridType,
              width: this.gridWidth,
              height: this.gridHeight,
              color: this.gridColor,
            },
            background: {
              image: this.background.image,
              color: this.backgroundColor,
            },

            width: this.boardWidth,
            height: this.boardHeight,
          }
        },
      },
    },

    methods: {
      changePage() {
        const page = this.currentPage

        this.$cable.perform({
          channel: 'GameChannel',
          action: 'change',
          data: { page_params: this.pageParams, id: page.id, name: page.name, type: 'page' },
        })
      },

      openPageColorSelect() {
        const key = Date.now()
        this.$store.commit('game/addOpenModal', {
          key,
          name: 'color-picker',
          target: this.targetPage,
          startColor: { hex: this.privatePageColor || this.background.color },
        })
      },

      openGridColorSelect() {
        const key = Date.now()
        this.$store.commit('game/addOpenModal', {
          key,
          name: 'color-picker',
          target: this.targetGrid,
          startColor: this.privateGridColor || this.grid.color,
        })
      },
    },
  }
</script>

<style scoped lang="scss">
  @import '~assets/css/colors';

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
