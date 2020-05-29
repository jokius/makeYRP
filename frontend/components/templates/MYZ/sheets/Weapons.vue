<template>
  <div class="grid">
    <div class="grid-title">
      <span class="title">Оружие</span>
      <img class="dice" src="/images/MYZ/explosion.png" alt="кубик снаряжения" />
    </div>
    <div class="grid-body">
      <div class="grid-item headers">
        <span>Название</span>
        <span>Качество</span>
        <span>Урон</span>
        <span>Дистанция</span>
        <span>Свойства</span>
      </div>
      <div
        v-for="(item, index) in weapons"
        :key="`weapon-${index}`"
        class="grid-item"
      >
        <v-text-field
          :value="item.name"
          color="indigo"
          class="input"
          hide-details
          @input="value => input(index, 'name', value)"
          @change="saveSheet"
        />
        <v-text-field
          :value="item.bonus"
          color="indigo"
          class="input"
          hide-details
          type="number"
          @input="value => input(index, 'bonus', parseInt(value, 10) || null)"
          @change="saveSheet"
        />
        <v-text-field
          :value="item.damage"
          color="indigo"
          class="input"
          hide-details
          type="number"
          @input="value => input(index, 'damage', parseInt(value, 10) || null)"
          @change="saveSheet"
        />
        <v-select
          :value="item.range"
          :items="rages"
          color="indigo"
          class="input"
          hide-details
          @change="value => change(index, 'range', value)"
        />
        <v-text-field
          v-model="item.special"
          color="indigo"
          class="input"
          hide-details
          @input="value => input(index, 'special', value)"
          @change="saveSheet"
        />
        <v-btn
          color="red darken-4"
          icon
          dark
          @click="remove(index)"
        >
          <v-icon>mdi-delete</v-icon>
        </v-btn>
      </div>
    </div>
    <div class="actions">
      <v-btn small @click="addWeapon">
        Добавить
      </v-btn>
      <span class="spacer" />
      <v-btn small @click="modalOpen = true">
        Добавить старндартное
      </v-btn>
    </div>
    <add-weapon-modal v-model="obj" />
  </div>
</template>

<script>
  import { mapState } from 'vuex'
  import { isEmpty } from 'lodash'

  import AddWeaponModal from '../modals/AddWeaponModal'

  export default {
    name: 'Weapons',
    components: { AddWeaponModal },
    props: {
      sheet: { type: Object, required: true },
    },

    data() {
      return {
        modalOpen: false,

        // TODO: move it to tables
        rages: [
          'Нулевая(-3)',
          'Ближняя(0)',
          'Средняя(-1)',
          'Дальняя(-2)',
        ],
      }
    },

    computed: {
      ...mapState({
        tables: state => state.game.info.template.tables,
      }),

      weapons: {
        get() {
          return this.sheet.params.weapons
        },
      },

      gear: {
        get() {
          return this.sheet.params.gear
        },
      },

      obj: {
        get() {
          return { open: this.modalOpen, weapon: {} }
        },

        set({ open, weapon }) {
          this.setWeapon(weapon)
          this.modalOpen = open
        },
      },
    },

    methods: {
      input(index, target, value) {
        this.$store.commit('game/updateSheetParams',
                           {
                             id: this.sheet.id,
                             path: `weapons.${index}.${target}`,
                             value: value,
                           })

      },

      change(index, target, value) {
        this.$store.commit('game/updateSheetParams',
                           {
                             id: this.sheet.id,
                             path: `weapons.${index}.${target}`,
                             value: value,
                           })

        this.saveSheet()
      },

      remove(index) {
        this.$store.commit('game/updateSheetParams',
                           {
                             id: this.sheet.id,
                             path: 'weapons',
                             value: index,
                             remove: true,
                           })

        this.saveSheet()
      },

      setWeapon(weapon) {
        if (isEmpty(weapon)) return

        this.$store.commit('game/updateSheetParams',
                           {
                             id: this.sheet.id,
                             path: `weapons.${this.weapons.length}`,
                             value: weapon,
                           })

        const item = {
          name: weapon.name,
          size: weapon.size,
          number: 1,
        }

        this.$store.commit('game/updateSheetParams',
                           {
                             id: this.sheet.id,
                             path: `gear.${this.gear.length}`,
                             value: item,
                           })

        this.saveSheet()
      },

      addWeapon() {
        const weapon = {
          name: '',
          bonus: 0,
          damage: 1,
          range: this.rages[0],
          special: '',
        }

        this.$store.commit('game/updateSheetParams',
                           {
                             id: this.sheet.id,
                             path: `weapons.${this.weapons.length}`,
                             value: weapon,
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
  @import '~assets/css/colors';

  $title_height: 35px;
  $border: 1px solid $black;

  .grid {
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: $title_height max-content;
  }

  .grid-title {
    display: grid;
    grid-template-columns: 1fr max-content;
    background-image: url("/images/MYZ/weapon.jpeg");
    background-size: cover;
    background-color: $orangeE9;
  }

  .grid-body {
    display: grid;
    grid-template-columns: 1fr;
  }

  .grid-item {
    display: grid;
    grid-template-columns: 152px 76px 44px 100px 140px 30px;
  }

  .headers {
    border-bottom: $border;
  }

  .dice {
    margin-top: 3px;
    width: 30px;
    height: 30px;
    background-color: $black;
    border-radius: 8px;
    margin-right: 2px;
  }

  .title {
    font-size: 2.5rem;
    font-weight: bold;
    color: $white;
    padding-left: 5px;
    vertical-align: middle;
    line-height: $title_height;
  }

  .text {
    vertical-align: middle;
    line-height: $title_height;
  }

  .input {
    margin: 0;
    padding: 3px 0 0;
    border-right: $border;
    background-color: $white;
  }

  .actions {
    display: grid;
    grid-template-columns: max-content auto max-content;
    grid-row-gap: 5px;
    margin: 5px;
  }
</style>
