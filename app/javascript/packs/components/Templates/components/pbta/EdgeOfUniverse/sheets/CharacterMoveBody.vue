<template>
  <div class="moves-body">
    <v-expansion-panels v-model="panels" hover multiple>
      <v-expansion-panel>
        <v-expansion-panel-header class="gray">Базовые ходы</v-expansion-panel-header>
        <v-expansion-panel-content class="gray">
          <move
            v-for="(move, index) in baseMoves"
            :key="`base-moves-${index}`"
            :sheet="sheet"
            :move="move"
            :index="index"
          />
        </v-expansion-panel-content>
      </v-expansion-panel>
      <v-expansion-panel>
        <v-expansion-panel-header class="gray">Ходы роли</v-expansion-panel-header>
        <v-expansion-panel-content class="gray">
          <move
            v-for="(move, index) in moves"
            :key="`moves-${index}`"
            :sheet="sheet"
            :move="move"
            :index="index"
          />
        </v-expansion-panel-content>
      </v-expansion-panel>
      <v-expansion-panel>
        <v-expansion-panel-header class="gray">Опциональные ходы</v-expansion-panel-header>
        <v-expansion-panel-content class="gray">
          <move
            v-for="(move, index) in optionalMoves"
            :key="`optional-moves-${index}`"
            :sheet="sheet"
            :move="move"
            :index="index"
          />
        </v-expansion-panel-content>
      </v-expansion-panel>
      <v-expansion-panel>
        <v-expansion-panel-header class="gray">Космические ходы</v-expansion-panel-header>
        <v-expansion-panel-content class="gray">
          <move
            v-for="(move, index) in spaceMoves"
            :key="`space-moves-${index}`"
            :sheet="sheet"
            :move="move"
            :index="index"
          />
        </v-expansion-panel-content>
      </v-expansion-panel>
    </v-expansion-panels>

    <div class="actions">
      <v-spacer />
      <v-btn
        class="button-add"
        raised
        color="black"
        dark
        @click="specialMoves"
      >
        Добавить Специальный ход
      </v-btn>
      <v-spacer />
      <v-btn
        class="button-add"
        raised
        color="black"
        dark
        @click="otherMoves"
      >
        Добавить Мировой ход
      </v-btn>
      <v-spacer />
    </div>

    <add-move-modal v-if="modalOpen" v-model="obj" :select-moves="selectMoves" :moves="moves" />
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
        panels: [],
        modalOpen: false,
        selectMoves: [],
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
      specialMoves() {
        this.selectMoves = this.mapMoves(this.tables.specialMoves[this.params.role.key])
        this.modalOpen = true
      },

      otherMoves() {
        const role = this.params.role.key
        const list = this.tables.specialMoves
        let result = []

        for (let key in list) {
          if (role !== key) {
            const name = this.tables.roles.find(item => item.key === key).name
            result.push({ text: name, value: false, disabled: true })
            result = result.concat(this.mapMoves(list[role]))
          }
        }

        this.selectMoves = result
        this.modalOpen = true
      },

      mapMoves(list) {
        return list.map(item => {
          if (this.moves.find(move => move.name === item.name)) return
          const value = item
          value.remove = true

          return {
            text: item.name,
            value,
          }
        }).filter(Boolean)
      },

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

  .gray {
    background-color: $grayC5;
  }

  .actions {
    display: grid;
    grid-template-columns: 1fr max-content 10px max-content 1fr;
    margin-top: 15px;
  }
</style>
