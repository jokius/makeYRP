<template>
  <div class="moves-body">
    <div class="special-moves">
      <p class="moves-title">Особые ходы</p>
      <move :sheet="sheet" :move="{ name: 'Ход страха', description: fearMove }" :index="0" />
      <move :sheet="sheet" :move="{ name: 'Ход смерти', description: deadMove }" :index="0" />
    </div>
    <div class="base-moves">
      <p class="moves-title">Базовые ходы</p>
      <move
        v-for="(move, index) in baseMoves"
        :key="`base-moves-${index}`"
        :sheet="sheet"
        :move="move"
        :index="0"
      />
    </div>
    <div class="archetypes-moves">
      <p class="moves-title">Ходы архетипа</p>
      <p class="moves-hint">Выбери два хода.</p>
      <move
        v-for="(move, index) in moves"
        :key="`base-moves-${index}`"
        :sheet="sheet"
        :move="move"
        :index="index"
      />
    </div>
    <div class="actions">
      <v-spacer />
      <v-btn
        class="button-add"
        rounded
        @click="modalOpen = true"
      >
        Добавить действие
      </v-btn>
      <v-spacer />
    </div>

    <add-move-modal v-if="modalOpen" v-model="obj" :role="sheet.params.role" :moves="sheet.params.moves" />
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import Move from './Move'

  import { UPDATE_SHEET_PARAMS } from '../../../../../Games/stores/mutation-types'
  import AddMoveModal from '../modals/AddMoveModal'

  export default {
    name: 'CharacterMoveBody',
    components: { AddMoveModal, Move },
    props: {
      id: { type: Number, required: true },
    },

    data() {
      return {
        modalOpen: false,
      }
    },

    computed: {
      ...mapState({
        sheets: state => state.game.sheets,
        tables: state => state.game.info.template.tables,
      }),

      sheet: {
        get() {
          return this.sheets.find(sheet => sheet.id === this.id)
        },
      },

      fearMove: {
        get() {
          return this.sheet.params.fearMove
        },
      },

      deadMove: {
        get() {
          return this.sheet.params.deadMove
        },
      },

      baseMoves: {
        get() {
          return this.tables.baseMoves
        },
      },

      moves: {
        get() {
          return this.sheet.params.moves
        },
      },

      obj: {
        get() {
          return { open: this.modalOpen, move: {} }
        },

        set({ open, move }) {
          this.setMove(move)
          this.modalOpen = open
        },
      },
    },

    methods: {
      setMove(move) {
        if (!move.name) return

        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `moves[${this.moves.length}]`,
                             value: move,
                           })

        this.saveSheet()
      },

      saveSheet() {
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'change',
          data: { ...this.sheet, type: 'sheet' },
        })
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .moves-body {
    background-color: $grayC5;
    overflow: auto;
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: max-content;
    padding: 0 5px;
    height: 570px;
  }

  .special-moves {
    margin-bottom: 5px;
  }

  .moves-title {
    margin-top: 5px;
    margin-bottom: 5px;
    font-size: 20px;
    font-weight: bold;
    text-align: center;
  }

  .moves-hint {
    font-style: italic;
    text-align: center;
  }

  .actions {
    display: grid;
    grid-template-columns: 1fr max-content 1fr;
    grid-row-gap: 5px;
    margin: 5px;
  }
</style>
