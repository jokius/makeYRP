<template>
  <div class="moves-body">
    <details class="moves" open>
      <summary class="moves-title">Базовые ходы</summary>
      <div class="moves-grid">
        <move
          v-for="(move, index) in baseMoves"
          :key="`base-moves-${index}`"
          :sheet="sheet"
          :move="move"
          :index="index"
          path="moves"
        />
      </div>
    </details>
    <details class="moves" open>
      <summary class="moves-title">Ходы роли</summary>
      <div class="moves-grid">
        <move
          v-for="(move, index) in moves"
          :key="`moves-${index}`"
          :sheet="sheet"
          :move="move"
          :index="index"
          path="moves"
        />
      </div>
      <div class="actions">
        <v-btn
          class="button-add"
          raised
          color="black"
          dark
          @click="specialMovesOpen = true"
        >
          Добавить Специальный ход
        </v-btn>
        <v-spacer />
        <v-btn
          class="button-add"
          raised
          color="black"
          dark
          @click="otherMovesOpen = true"
        >
          Добавить Мировой ход
        </v-btn>
      </div>
    </details>
    <details class="moves">
      <summary class="moves-title">Опциональные ходы</summary>
      <div class="moves-grid">
        <move
          v-for="(move, index) in optionalMoves"
          :key="`optional-moves-${index}`"
          :sheet="sheet"
          :move="move"
          :index="index"
          path="moves"
        />
      </div>
    </details>
    <details class="moves">
      <summary class="moves-title">Космические ходы</summary>
      <div class="moves-grid">
        <move
          v-for="(move, index) in spaceMoves"
          :key="`space-moves-${index}`"
          :sheet="sheet"
          :move="move"
          :index="index"
          path="moves"
        />
      </div>
    </details>

    <add-move-modal
      v-if="specialMovesOpen"
      :id="id"
      :obj="specialMoveObj"
      @completed="value => specialMoveObj = value"
    />
    <add-world-move-modal
      v-if="otherMovesOpen"
      :id="id"
      :obj="otherMoveObj"
      @completed="value => otherMoveObj = value"
    />
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import Move from './Move'

  import { UPDATE_SHEET_PARAMS } from '../../../../../Games/stores/mutation-types'
  import AddMoveModal from '../modals/AddMoveModal'
  import AddWorldMoveModal from '../modals/AddWorldMoveModal'

  export default {
    name: 'CharacterMoveBody',
    components: { AddWorldMoveModal, AddMoveModal, Move },
    props: {
      id: { type: Number, required: true },
    },

    data() {
      return {
        panels: [],
        specialMovesOpen: false,
        otherMovesOpen: false,
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

      params: {
        get() {
          return this.sheet.params
        },
      },

      baseMoves: {
        get() {
          return this.tables.baseMoves
        },
      },

      moves: {
        get() {
          return this.params.moves
        },
      },

      optionalMoves: {
        get() {
          return this.tables.optionalMoves
        },
      },

      spaceMoves: {
        get() {
          return this.tables.spaceMoves
        },
      },

      specialMoveObj: {
        get() {
          return { open: this.specialMovesOpen, move: {} }
        },

        set({ open, move }) {
          this.setMove(move)
          this.specialMovesOpen = open
        },
      },

      otherMoveObj: {
        get() {
          return { open: this.otherMovesOpen, move: {} }
        },

        set({ open, move }) {
          this.setMove(move)
          this.otherMovesOpen = open
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
  }

  .moves {
    cursor: pointer;
    margin-bottom: 5px;
  }

  .moves-title {
    margin-top: 5px;
    margin-bottom: 5px;
    font-size: 20px;
    font-weight: bold;
    text-align: center;
  }

  .moves-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    grid-column-gap: 15px;
  }

  .gray {
    background-color: $grayC5;
  }

  .actions {
    display: grid;
    grid-template-columns: max-content 10px max-content;
    justify-content: center;
    margin-top: 15px;
    margin-bottom: 5px;
  }
</style>
