<template>
  <div class="main-body">
    <div class="main-row1">
      <div class="main-row1-col1">
        <avatar :sheet="sheet" />
        <div class="resources">
          <img src="/img/strongbox.svg" class="icon" alt="Благосостояние" />
          <div
            v-for="number in 5"
            :key="`welfare-${number}`"
            class="box-line"
            @click="welfare = number"
          >
            <div :class="[{ enable: welfare >= number }, 'box']" />
          </div>
          <img src="/img/banknote.svg" class="icon" alt="Прибыль" />
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
            class="input"
            color="indigo"
            @change="(value) => role = value"
          />
          <v-select
            v-model="appearance"
            :items="appearances"
            class="input"
            color="indigo"
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
                <img src="/img/fist.svg" class="icon" alt="Урон" />
                <div
                  v-for="number in 5"
                  :key="`damage-${number}`"
                  class="box-line"
                  @click="damage = number"
                >
                  <div :class="[{enable: damage >= number }, 'box']" />
                </div>
              </div>
              <div class="protection">
                <img src="/img/riot-shield.svg" class="icon" alt="Защита" />
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
                <img src="/img/health-normal.svg" class="icon" alt="Здоровье" />
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
                <img src="/img/ammo-box.svg" class="icon" alt="Припасы" />
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
    <div class="main-row2">
      <v-expansion-panels v-model="panel" flat hover>
        <v-expansion-panel>
          <v-expansion-panel-header>Описание</v-expansion-panel-header>
          <v-expansion-panel-content>
            {{ description }}
          </v-expansion-panel-content>
        </v-expansion-panel>
      </v-expansion-panels>
    </div>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import Avatar from './Avatar'

  import { UPDATE_SHEET_NAME, UPDATE_SHEET_PARAMS } from '../../../../../Games/stores/mutation-types'
  import { Pbta } from '../../../../../../lib/Pbta'

  export default {
    name: 'CharacterMainBody',
    components: { Avatar },

    props: {
      id: { type: Number, required: true },
    },

    data() {
      return {
        modalOpen: false,
        currentCharacteristic: {},
        panel: 0,
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

      obj: {
        get() {
          return { open: this.modalOpen, modifier: 0 }
        },

        set({ open, modifier, isClose }) {
          if (!isClose) this.roll(parseInt(modifier))
          this.modalOpen = open
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
    },

    created() {
      if (this.params.role === '@random') {
        this.changeRole(Pbta.randomRole(this.tableRoles).value)
        this.saveSheet()
      }
    },

    methods: {
      openModal(characteristic){
        this.modalOpen = true
        this.currentCharacteristic = characteristic
      },

      changeRole(roleName) {
        const role = this.tables.roles.find(item => item.key === roleName)
        this.input('role', role)
        this.changeStats()
        this.changeRoleAppearance()
        this.changeRoleDescription()
        // this.changeRelationship(roleName)
        // this.changeMoves(roleName)
        // this.changeSpecials(roleName)
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

      changeRoleAppearance() {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'appearance',
                             value: this.appearances[0] || '',
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

      changeRelationship() {
        const roleRelationship = this.tables.relationship[this.role] || []
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'relationship',
                             value: roleRelationship,
                           })
      },

      changeMoves(role) {
        const roleMoves = this.tables.moves[role] || []
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'moves',
                             value: roleMoves,
                           })

        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'fearMove',
                             value: this.tables.fearMove[role] || "",
                           })

        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'deadMove',
                             value: this.tables.deadMove[role] || "",
                           })
      },

      changeSpecials(role) {
        const roleSpecials = this.tables.specials[role] || []
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'specials',
                             value: roleSpecials,
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

      roll(modifier) {
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'add',
          data: {
            type: 'message',
            body: {
              as: this.sheet.id,
              name: this.currentCharacteristic.name,
              dices: { d6: 2 },
              characteristic: this.currentCharacteristic,
              modifier,
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





  .stat-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
  }

  .characteristics-grid {
    display: grid;
    grid-auto-flow: column;
    grid-column-gap: 20px;
    margin-right: 5px;
    height: 127px;
  }

  .characteristic {
    background: $white;
    border: 1px solid $black;
  }

  .characteristic-title-text {
    font-size: 25px;
  }

  .button {
    cursor: pointer;
  }

  .black {
    background-color: $black;
    color: $white;
    text-align: center;
  }

  .number {
    font-weight: bold;
    font-size: 25px;
    margin: 0;
    text-align: center;
    height: 60px;
    line-height: 60px;
  }

  .checkbox-injury {
    margin: 0;
  }

  .enable {
    background-color: $black;
  }

  .characteristics-select {
    height: 20px;
  }

  .specials {
    margin-top: 10px;
    margin-left: 5px;
    margin-right: 5px;
    width: 99%;
  }

  .special-title {
    font-weight: bold;
    font-size: 25px;
    margin: 0;
  }

  .special-select {
    margin: 0;
  }

  .notes {
    margin-right: 5px;
    margin-bottom: 5px;
  }

  .role-title {
    margin-right: 2px;
    font-weight: bold;
    font-style: italic;
  }
</style>
