<template>
  <div class="main-body">
    <div class="main-row1">
      <div class="main-row1-col1">
        <avatar :sheet="sheet" />
        <div class="resources">
          <img src="/img/strongbox.svg" class="icon" title="Благосостояние" alt="Благосостояние" />
          <div
            v-for="number in 5"
            :key="`welfare-${number}`"
            class="box-line"
            @click="welfare = number"
          >
            <div :class="[{ enable: welfare >= number }, 'box']" />
          </div>
          <img src="/img/banknote.svg" class="icon" title="Прибыль" alt="Прибыль" />
          <div
            v-for="number in 3"
            :key="`profit-${number}`"
            class="box-line"
            @click="profit = number"
          >
            <div :class="[{ enable: profit >= number }, 'box']" />
          </div>
        </div>
      </div>
      <div class="main-row1-col2">
        <div class="main-row1-col2-base-info">
          <v-text-field
            v-model="name"
            color="indigo"
            class="input name"
            flat
            @change="saveSheet"
          />
          <v-select
            :value="role.key"
            :items="tableRoles"
            label="Роль"
            class="input"
            color="indigo"
            @change="(value) => role = value"
          />
          <div class="attributes">
            <div class="attributes-col1">
              <div class="state">
                <span class="state-label">ЯРОСТЬ</span>
                <input
                  v-model.number="fury"
                  class="state-input"
                  type="number"
                  @change="saveSheet"
                />
              </div>
              <div class="state">
                <span class="state-label">КОНТРОЛЬ</span>
                <input
                  v-model.number="control"
                  class="state-input"
                  type="number"
                  @change="saveSheet"
                />
              </div>
              <div class="state">
                <span class="state-label">НАВЫК</span>
                <input
                  v-model.number="skill"
                  class="state-input"
                  type="number"
                  @change="saveSheet"
                />
              </div>
              <div class="state">
                <span class="state-label">РЕПУТАЦИЯ</span>
                <input
                  v-model.number="reputation"
                  class="state-input"
                  type="number"
                  @change="saveSheet"
                />
              </div>
            </div>
            <div class="attributes-col2">
              <div class="damage">
                <img src="/img/fist.svg" class="icon" title="Урон" alt="Урон" />
                <div
                  v-for="number in 5"
                  :key="`damage-${number}`"
                  class="box-line"
                  @click="damage = number"
                >
                  <div :class="[{enable: damage >= number }, 'box']" />
                </div>
                <div>
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
              <div class="protection">
                <img src="/img/riot-shield.svg" class="icon" title="Защита" alt="Защита" />
                <div
                  v-for="number in 5"
                  :key="`protection-${number}`"
                  class="box-line"
                  @click="protection = number"
                >
                  <div :class="[{enable: protection >= number }, 'box']" />
                </div>
              </div>
              <div class="hp">
                <img src="/img/health-normal.svg" class="icon" title="Здоровье" alt="Здоровье" />
                <div
                  v-for="number in hp.max"
                  :key="`hp-${number}`"
                  class="box-line"
                  @click="hp = number"
                >
                  <div :class="[{enable: hp.current >= number }, 'box']" />
                </div>
              </div>
              <div class="supply">
                <img src="/img/ammo-box.svg" class="icon" title="Припасы" alt="Припасы" />
                <div
                  v-for="number in 10"
                  :key="`supply-${number}`"
                  class="box-line"
                  @click="supply = number"
                >
                  <div :class="[{enable: supply >= number }, 'box']" />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <specials :id="id" />
    <div class="main-row2">
      <v-select
        v-model="origin"
        :items="origins"
        :label="originTitle"
        class="input"
        color="indigo"
        @change="saveSheet"
      />
      <div class="origin" v-html="origin" />
      <v-expansion-panels flat hover>
        <v-expansion-panel>
          <v-expansion-panel-header>Описание</v-expansion-panel-header>
          <v-expansion-panel-content>
            {{ description }}
            <br />
            <br />
            <div>Примеры внешности:</div>
            <div v-for="example in appearances" :key="example">
              <span>{{ example }}</span>
            </div>
          </v-expansion-panel-content>
        </v-expansion-panel>
      </v-expansion-panels>
      <v-textarea
        v-model="appearance"
        auto-grow
        no-resize
        rows="1"
        color="indigo"
        background-color="white"
        class="notes"
        hide-details
        label="Внешность"
        @change="saveSheet"
      />
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

    <roll-damage-modal v-model="obj" />
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import Avatar from './Avatar'
  import Specials from './Specials'

  import { UPDATE_SHEET_NAME, UPDATE_SHEET_PARAMS } from '../../../../../Games/stores/mutation-types'
  import { Pbta } from '../../../../../../lib/Pbta'
  import RollDamageModal from '../modals/RollDamageModal'

  export default {
    name: 'CharacterMainBody',
    components: { RollDamageModal, Specials, Avatar },

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
          this.$store.commit(UPDATE_SHEET_NAME, { id: this.sheet.id, name })
        },
      },

      role: {
        get() {
          return this.params.role
        },

        set(value) {
          this.changeRole(value)
          this.saveSheet()
        },
      },

      origins: {
        get() {
          return this.tables.origin[this.role.key].list.map(item => ({ text: item.value, value: item.description }))
        },
      },

      originTitle: {
        get() {
          return this.tables.origin[this.role.key].title
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

      fury: {
        get() {
          return this.params.stats.fury
        },

        set(value) {
          this.input('stats.fury', value)
        },
      },

      control: {
        get() {
          return this.params.stats.control
        },

        set(value) {
          this.input('stats.control', value)
        },
      },

      skill: {
        get() {
          return this.params.stats.skill
        },

        set(value) {
          this.input('stats.skill', value)
        },
      },

      reputation: {
        get() {
          return this.params.stats.reputation
        },

        set(value) {
          this.input('stats.reputation', value)
        },
      },

      damage: {
        get() {
          return this.params.damage
        },

        set(value) {
          this.inputBox('damage', value, 5)
        },
      },

      protection: {
        get() {
          return this.params.protection
        },

        set(value) {
          this.inputBox('protection', value, 5)
        },
      },

      hp: {
        get() {
          return this.params.hp
        },

        set(value) {
          this.inputBox('hp.current', value, this.params.hp.max)
        },
      },

      supply: {
        get() {
          return this.params.supply
        },

        set(value) {
          this.inputBox('supply', value, 10)
        },
      },

      welfare: {
        get() {
          return this.params.stats.welfare
        },

        set(value) {
          this.inputBox('stats.welfare', value, 5)
        },
      },

      profit: {
        get() {
          return this.params.profit
        },

        set(value) {
          this.inputBox('profit', value, 3)
        },
      },

      tableRoles: {
        get() {
          return this.tables.roles.map(item => (
            { value: item.key, text: item.name }
          ))
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

      appearances: {
        get() {
          return this.tables.roleAppearances[this.role.key] || []
        },
      },

      appearance: {
        get() {
          return this.params.appearance
        },

        set(value) {
          this.input('appearance', value)
        },
      },

      description: {
        get() {
          return this.params.description
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

    created() {
      if (this.params.role === '@random') {
        this.changeRole(Pbta.randomRole(this.tableRoles).value)
        this.saveSheet()
      }
    },

    methods: {
      changeRole(roleName) {
        const role = this.tables.roles.find(item => item.key === roleName)
        this.input('role', role)
        this.changeStats()
        this.changeRoleDescription()
        this.changeSpecials()
        this.changeMoves()
        this.changeEquipment()
        this.changeRelationship()
      },

      changeStats() {
        const role = this.tables.roles.find(item => item.key === this.role.key)

        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'hp',
                             value: role.hp,
                           })

        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'stats.welfare',
                             value: role.welfare,
                           })

        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'damage',
                             value: role.damage,
                           })

        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'supply',
                             value: role.supply,
                           })
      },

      changeRoleDescription() {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'description',
                             value: this.tables.roleDescription[this.role.key] || '',
                           })
      },

      changeMoves() {
        let moves = this.tables.startMoves[this.role.key] || []
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'moves',
                             value: moves,
                           })
      },

      changeEquipment() {
        let equipment = this.tables.startingEquipment[this.role.key] || []
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'equipment',
                             value: equipment,
                           })
      },

      changeSpecials() {
        const roleSpecials = this.tables.specials[this.role.key] || []
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'specials',
                             value: roleSpecials,
                           })
      },

      changeRelationship() {
        const roleRelationship = this.tables.relationship[this.role.key] || []
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'relationship',
                             value: roleRelationship,
                           })
      },

      saveSheet() {
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'change',
          data: { ...this.sheet, type: 'sheet' },
        })
      },

      input(target, value) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: target,
                             value: value,
                           })
      },

      inputBox(target, number, max) {
        let value = this.params[target] < max ? number : 0
        value = number === this.params[target] && number === 1 ? 0 : number
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: target,
                             value: value,
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
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

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
    grid-template-columns: 1fr;
    grid-template-rows: max-content;
    margin-left: 5px;
  }

  .input {
    margin: 0;
    padding: 0;
  }

  .name {
    margin-top: 10px;
  }

  .resources {
    margin-top: 10px;
  }

  .attributes {
    display: grid;
    grid-template-columns: 1fr max-content;
    grid-column-gap: 15px;
  }

  .attributes-col1 {
    display: grid;
    grid-row-gap: 5px;
  }

  .attributes-col2 {
    display: grid;
    grid-row-gap: 5px;
  }

  .state {
    display: grid;
    grid-template-columns: 1fr 50px;
    background-color: $black;
    color: $white;
    height: 35px;
    line-height: 35px;
  }

  .state-label {
    margin-left: 10px;
  }

  .state-input {
    margin: 0;
    text-align: center;
    height: 35px;
    line-height: 35px;
    background-color: $white;
    color: $black;
    border: 3px solid $black;
  }

  .icon {
    width: 35px;
    height: 35px;
  }

  .box-line {
    display: inline-flex;
  }

  .box {
    position: relative;
    bottom: 8px;
    cursor: pointer;
    width: 20px;
    height: 20px;
    margin-left: 5px;
    border: 2px solid $black;
    background-color: $white;
  }

  .black {
    background-color: $black;
    color: $white;
    text-align: center;
  }

  .button-damage {
    margin-left: 5px;
  }

  .enable {
    background-color: $black;
  }

  .specials {
    margin-top: 10px;
    margin-left: 5px;
    margin-right: 5px;
    width: 99%;
  }

  .origin {
    margin-bottom: 5px;
  }

  .notes {
    margin-right: 5px;
    margin-bottom: 5px;
  }
</style>
