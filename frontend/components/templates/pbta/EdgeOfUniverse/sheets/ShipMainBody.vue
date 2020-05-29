<template>
  <div class="main-body">
    <div class="main-row1">
      <div class="main-row1-col1">
        <avatar :sheet="sheet" />
      </div>
      <div class="main-row1-col2">
        <div class="main-row1-col2-base-info">
          <v-text-field
            v-model="name"
            color="indigo"
            class="name"
            flat
            @change="saveSheet"
          />

          <div class="attributes">
            <span class="state-label">Броня</span>
            <v-text-field
              v-model.number="protection"
              color="indigo"
              class="input"
              flat
              type="number"
              @change="saveSheet"
            />
            <v-text-field
              v-model.number="protectionMax"
              color="indigo"
              class="input"
              flat
              type="number"
              @change="saveSheet"
            />

            <span class="state-label">Заряды реактора</span>
            <v-text-field
              v-model.number="energy"
              color="indigo"
              class="input"
              flat
              type="number"
              @change="saveSheet"
            />
            <v-text-field
              v-model.number="energyMax"
              color="indigo"
              class="input"
              flat
              type="number"
              @change="saveSheet"
            />

            <span class="state-label">Урон</span>
            <v-text-field
              v-model.number="damage"
              color="indigo"
              class="input"
              flat
              type="number"
              @change="saveSheet"
            />
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
        </div>
      </div>
    </div>
    <div class="main-row2">
      <v-select
        v-model="origin"
        :items="origins"
        :label="originTitle"
        class="input-select"
        color="indigo"
        @change="saveSheet"
      />
      <div class="origin" v-html="origin" />
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
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import Avatar from './Avatar'

  import RollDamageModal from '../modals/RollDamageModal'

  export default {
    name: 'ShipMainBody',
    components: { RollDamageModal, Avatar },

    props: {
      id: { type: Number, required: true },
    },

    data() {
      return {
        modalOpen: false,
        modalModifierOpen: false,
        currentState: {},
      }
    },

    computed: {
      ...mapState({
        sheets: state => state.game.sheets,
        tables: state => state.game.info.template.tables,
        specialTabs: state => state.game.specialTabs,
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

      name: {
        get() {
          return this.sheet.name
        },
        set(name) {
          this.$store.commit('game/updateSheetName', { id: this.sheet.id, name })
        },
      },

      hp: {
        get() {
          return this.params.hp.current
        },

        set(value) {
          this.input('hp.current', value)
        },
      },

      hpMax: {
        get() {
          return this.params.hp.max
        },

        set(value) {
          this.input('hp.max', value)
        },
      },

      protection: {
        get() {
          return this.params.protection.current
        },

        set(value) {
          this.input('protection.current', value)
        },
      },

      protectionMax: {
        get() {
          return this.params.protection.max
        },

        set(value) {
          this.input('protection.max', value)
        },
      },

      energy: {
        get() {
          return this.params.energy.current
        },

        set(value) {
          this.input('energy.current', value)
        },
      },

      energyMax: {
        get() {
          return this.params.energy.max
        },

        set(value) {
          this.input('energy.max', value)
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

      origins: {
        get() {
          return this.tables.shipOrigin.list.map(item => ({ text: item.value, value: item.description }))
        },
      },

      originTitle: {
        get() {
          return this.tables.shipOrigin.title
        },
      },

      origin: {
        get() {
          return this.params.origin
        },

        set(value) {
          this.input('origin', value)
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

      obj: {
        get() {
          return { open: this.modalOpen, dices: 1 }
        },

        set({ open, dices, isClose }) {
          if (!isClose) this.rollDamage(parseInt(dices))
          this.modalOpen = open
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

      saveSheet() {
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'change',
          data: { ...this.sheet, type: 'sheet' },
        })
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
  }

  .main-row2 {
    display: grid;
    grid-template-columns: 0.99fr;
    grid-template-rows: max-content;
    margin-left: 5px;
  }

  .name {
    padding: 0;
    margin: 10px 0 0;
  }

  .input {
    width: 100px;
    margin: 0;
    padding: 0;
  }

  .attributes {
    display: grid;
    grid-template-columns: repeat(3, max-content);
    grid-column-gap: 10px;
    justify-content: center;
    height: 35px;
    line-height: 35px;
  }

  .box-line {
    display: inline-flex;
  }

  .button-damage {
    margin-left: 5px;
  }

  .origin {
    margin-bottom: 5px;
  }

  .notes {
    margin-right: 5px;
    margin-bottom: 5px;
  }
</style>
