<template>
  <div class="main-body">
    <div class="main-row1">
      <div class="main-row1-col1">
        <avatar :sheet="sheet" />
        <v-btn
          class="button-damage"
          raised
          color="black"
          dark
          @click="modalOpen = true"
        >
          Нанести урон
        </v-btn>
      </div>
      <div class="main-row1-col2">
        <div class="main-row1-col2-base-info">
          <v-select
            :value="enemySelect"
            :items="enemies"
            label="Стандартный противник"
            class="input name"
            color="indigo"
            @change="setEnemy"
          />
          <v-text-field
            v-model="name"
            color="indigo"
            class="input name"
            flat
            @change="saveSheet"
          />
          <div class="stats-grid">
            <v-text-field
              v-model.number="damage"
              color="indigo"
              class="input"
              label="Урон"
              flat
              type="number"
              @change="saveSheet"
            />
            <v-text-field
              v-model.number="protection"
              color="indigo"
              class="input"
              label="Защита"
              flat
              type="number"
              @change="saveSheet"
            />
            <v-text-field
              v-model.number="wounds"
              color="indigo"
              class="input"
              label="Ранения"
              flat
              type="number"
              @change="saveSheet"
            />
            <v-text-field
              v-model.number="woundsMax"
              color="indigo"
              class="input"
              label="Ранения макс"
              flat
              type="number"
              @change="saveSheet"
            />
          </div>

          <v-textarea
            v-model="description"
            auto-grow
            no-resize
            rows="2"
            color="indigo"
            background-color="white"
            class="notes"
            hide-details
            label="Описание"
            @change="saveSheet"
          />
        </div>
      </div>
    </div>
    <div class="main-row2">
      <div class="moves">
        <p class="moves-title">Ходы</p>
        <move
          v-for="(move, index) in moves"
          :key="`base-moves-${index}`"
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
          @click="movesOpen = true"
        >
          Добавить ход
        </v-btn>
      </div>

      <v-textarea
        v-model="notes"
        auto-grow
        no-resize
        rows="2"
        color="indigo"
        background-color="white"
        class="notes"
        hide-details
        label="Заметки"
        @change="saveSheet"
      />
    </div>
    <roll-damage-modal v-if="modalOpen" v-model="obj" :damage="damage" />
    <add-enemy-move-modal
      v-if="movesOpen"
      :id="id"
      :obj="moveObj"
      @completed="value => moveObj = value"
    />
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import Avatar from './Avatar'

  import RollDamageModal from '../modals/RollDamageModal'
  import Move from '../../HorrorMovieWorld/sheets/Move'
  import AddEnemyMoveModal from '../modals/AddEnemyMoveModal'

  export default {
    name: 'EnemyMainBody',
    components: { AddEnemyMoveModal, Move, RollDamageModal, Avatar },

    props: {
      id: { type: Number, required: true },
    },

    data() {
      return {
        modalOpen: false,
        movesOpen: false,
        currentState: {},
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

      roles: {
        get() {
          return this.tables.roles
        },
      },

      name: {
        get() {
          return this.sheet.name
        },
        set(name) {
          this.$store.commit('game/updateSheetName', { id: this.sheet.id, name })
        },
      },

      damage: {
        get() {
          return this.params.damage
        },

        set(value) {
          this.input('damage', value)
        },
      },

      protection: {
        get() {
          return this.params.protection
        },

        set(value) {
          this.input('protection', value)
        },
      },

      wounds: {
        get() {
          return this.params.wounds
        },

        set(value) {
          this.input('wounds', value)
        },
      },

      woundsMax: {
        get() {
          return this.params.woundsMax
        },

        set(value) {
          this.input('woundsMax', value)
        },
      },

      moves: {
        get() {
          return this.params.moves
        },
      },

      notes: {
        get() {
          return this.params.notes
        },

        set(value) {
          this.input('notes', value)
        },
      },

      description: {
        get() {
          return this.params.notes
        },

        set(value) {
          this.input('description', value)
        },
      },

      enemies: {
        get() {
          return this.tables.enemies.map(enemy => ({ text: enemy.name, value: enemy }))
        },
      },

      enemySelect: {
        get() {
          return this.enemies.find(enemy => enemy.text === this.name)
        }
      },

      obj: {
        get() {
          return { open: this.modalOpen, dices: 1 }
        },

        set({ open, dices, isClose }) {
          if (!isClose) this.rollDamage(parseInt(dices))
          this.modalOpen = open
        },
      },

      moveObj: {
        get() {
          return { open: this.movesOpen, move: {} }
        },

        set({ open, move }) {
          this.setMove(move)
          this.movesOpen = open
        },
      },
    },

    methods: {
      input(target, value) {
        this.$store.commit('game/updateSheetParams',
                           {
                             id: this.sheet.id,
                             path: target,
                             value: value,
                           })
      },

      openModifier(state) {
        this.currentState = state
        this.modalModifierOpen = true
      },

      setEnemy(value) {
        this.name = value.name
        this.description = value.description
        this.damage = value.damage
        this.protection = value.protection
        this.woundsMax = value.woundsMax
        const moves = []
        value.moves.forEach(name => {
          const move = this.tables.enemyMoves.find(move => move.name === name)
          move.remove = true
          moves.push(move)
        })

        this.$store.commit('game/updateSheetParams',
                           {
                             id: this.sheet.id,
                             path: `moves`,
                             value: moves,
                           })

        this.saveSheet()
      },

      setMove(move) {
        if (!move.name) return

        this.$store.commit('game/updateSheetParams',
                           {
                             id: this.sheet.id,
                             path: `moves[${this.moves.length}]`,
                             value: move,
                           })

        this.saveSheet()
      },

      rollDamage(dices) {
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'add',
          data: {
            type: 'message',
            body: {
              as: this.sheet.id,
              name: 'Урон',
              dices: { d6: dices },
              damage: true,
            },
          },
        })
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
  @import '~assets/css/colors';

  .main-body {
    background-color: $grayC5;
    overflow: auto;
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: repeat(2, max-content);
    grid-row-gap: 5px;
    height: 570px;
  }

  .main-row1 {
    display: grid;
    grid-template-columns: 200px 0.99fr;
    grid-template-rows: max-content;
    grid-column-gap: 10px;
    margin-right: 5px;
  }

  .main-row2 {
    display: grid;
    grid-template-columns: 0.99fr;
    grid-template-rows: max-content;
    margin-left: 5px;
    margin-right: 5px;
  }

  .input {
    margin: 0;
    padding: 0;
  }

  .name {
    margin-top: 10px;
  }

  .stats-grid {
    display: grid;
    grid-template-columns: repeat(4, 170px);
    grid-column-gap: 10px;
    justify-content: center;
    margin-top: 10px;
  }

  .moves-title {
    margin-top: 5px;
    margin-bottom: 5px;
    font-size: 20px;
    font-weight: bold;
    text-align: center;
  }

  .actions {
    display: grid;
    grid-template-columns: max-content;
    justify-content: center;
  }

  .notes {
    margin-bottom: 5px;
  }
</style>
