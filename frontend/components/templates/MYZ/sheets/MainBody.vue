<template>
  <div class="sheet-body">
    <div class="main-row1">
      <avatar :sheet="sheet" />
      <div class="main-row1-col2">
        <div class="main-row1-col2-base-info">
          <span class="label-base_info">Имя:</span>
          <v-text-field
            v-model="name"
            required
            color="indigo"
            class="input"
            flat
            @change="saveSheet"
          />
          <span class="label-base_info">Роль:</span>
          <v-select
            v-model="role"
            :items="roles"
            class="input"
            color="indigo"
            @change="saveSheet"
          />
        </div>
        <dices-pool :id="id" />
      </div>
    </div>
    <div class="main-row2">
      <div class="main-row2-col1">
        <attributes :sheet="sheet" />
        <conditions :sheet="sheet" />
        <critical-injuries :sheet="sheet" />
        <skills :sheet="sheet" />
      </div>
      <div class="main-row2-col2">
        <counters :sheet="sheet" />
        <mutations :sheet="sheet" />
        <talents :sheet="sheet" />
        <weapons :sheet="sheet" />
        <armor :sheet="sheet" />
        <gear :sheet="sheet" />
      </div>
    </div>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import Avatar from './Avatar'
  import DicesPool from './DicesPool'
  import Attributes from './Attributes'
  import Conditions from './Conditions'
  import CriticalInjuries from './CriticalInjuries'
  import Skills from './Skills'
  import Counters from './Counters'
  import Mutations from './Mutations'
  import Talents from './Talents'
  import Weapons from './Weapons'
  import Armor from './Armor'
  import Gear from './Gear'
  import { Myz } from '../../../../lib/Myz'

  export default {
    name: 'MainBody',
    components: {
      Gear,
      Armor,
      Weapons,
      Talents,
      Mutations,
      Counters,
      Skills,
      CriticalInjuries,
      Conditions,
      Attributes,
      DicesPool,
      Avatar,
    },
    props: {
      id: { type: Number, required: true },
    },

    data() {
      return {
        //TODO: replace to game.template.mutants_roles
        roles: [
          { text: 'Громила', value: 'enforcer' },
          { text: 'Железячник', value: 'gearhead' },
          { text: 'Разведчик', value: 'stalker' },
          { text: 'Делец', value: 'fixer' },
          { text: 'Собачник', value: 'dog_handler' },
          { text: 'Хронист', value: 'chronicler' },
          { text: 'Босс', value: 'boss' },
          { text: 'Раб', value: 'grunt' },
        ],
      }
    },

    computed: {
      ...mapState({
        sheets: state => state.game.sheets,
      }),

      sheet: {
        get() {
          return this.sheets.find(sheet => sheet.id === this.id)
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

      role: {
        get() {
          return this.sheet.params.info.role
        },

        set(value) {
          this.$store.commit('game/updateSheetParams',
                             {
                               id: this.sheet.id,
                               path: 'info.role',
                               value,
                             })
        },
      },
    },

    created() {
      if (this.sheet.params.info.role === '@random') {
        this.$store.commit('game/updateSheetParams',
                           {
                             id: this.sheet.id,
                             path: 'info.role',
                             value: Myz.randomRole(this.roles).value,
                           })
        this.saveSheet()
      }
    },

    methods: {
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

  .sheet-body {
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: 260px auto;
    grid-row-gap: 5px;
  }

  .main-row1 {
    display: grid;
    grid-template-columns: 200px 1fr;
    grid-template-rows: auto;
    grid-column-gap: 10px;
  }

  .main-row2 {
    display: grid;
    grid-template-columns: max-content 1fr;
    grid-template-rows: auto;
    grid-gap: 5px 5px;
  }

  .main-row1-col2 {
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: auto auto;
    grid-gap: 5px 1vw;
    margin-left: 15px;
  }

  .main-row2-col1 {
    display: grid;
    grid-template-columns: 400px;
    grid-auto-rows: max-content;
    grid-gap: 5px 5px;
  }

  .main-row2-col2 {
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: repeat(7, max-content);
    grid-gap: 5px 1vw;
  }

  .main-row1-col2-base-info {
    display: grid;
    grid-template-columns: max-content 150px max-content 140px;
    grid-column-gap: 10px;
  }

  .label-base_info {
    padding-top: 6px;
  }

  .input {
    padding: 0;
    margin: 0;
  }
</style>
