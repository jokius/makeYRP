<template>
  <div class="moves-body">
    <div class="special-moves">
      <p class="moves-title">Особые ходы</p>
      <move :sheet="sheet" :move="{ name: 'Ход страха', description: fearMove }" path="" />
      <move :sheet="sheet" :move="{ name: 'Ход смерти', description: deadMove }" path="" />
    </div>
    <div class="base-moves">
      <p class="moves-title">Базовые ходы</p>
      <move
        v-for="(move, index) in baseMoves"
        :key="`base-moves-${index}`"
        :sheet="sheet"
        :move="move"
        path=""
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
        :path="`moves[${index}].enable`"
      />
    </div>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import Move from './Move'

  export default {
    name: 'CharacterMoveBody',
    components: { Move },
    props: {
      id: { type: Number, required: true },
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
</style>
