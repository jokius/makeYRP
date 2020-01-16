<template>
  <div class="sheet-body">
    <div class="main-row1">
      <avatar :sheet="sheet" />
      <div class="main-row1-col2">
        <div class="main-row1-col2-base-info">
          <v-select
            v-model="role"
            :items="roles"
            label="Роль"
            class="role"
            color="indigo"
          />
          <v-text-field
            v-model="name"
            label="Название"
            color="indigo"
            class="name"
            flat
            @change="saveSheet"
          />
          <v-text-field
            v-model="reputation"
            label="Реноме"
            color="indigo"
            class="reputation"
            @change="saveSheet"
          />
          <v-text-field
            v-model="den"
            label="Логово"
            color="indigo"
            class="den"
            @change="saveSheet"
          />
          <div v-for="(additionalField, index) in additionalFields" :key="`additionalField-${index}`">
            <v-select
              v-if="additionalField.type === 'select'"
              :label="additionalField.label"
              :hint="`Выберете ${additionalField.max}`"
              :multiple="additionalField.multi"
              :value="additionalField.current"
              :items="additionalField.items"
              persistent-hint
              @change="value => changeAdditionalField(value, index)"
            />
          </div>
        </div>
      </div>
    </div>
    <div class="main-row2">
      <reputation-and-control :sheet="sheet" />
      <projects :sheet="sheet" />
      <div class="grid-money-suspicions">
        <team-money :sheet="sheet" />
        <suspicions :sheet="sheet" />
      </div>

    <v-textarea
      v-model="notes"
      auto-grow
      no-resize
      rows="2"
      color="indigo"
        class="input bgw notes"
      hide-details
      label="Заметки"
      @change="saveSheet"
    />
      <div class="footer" />
  </div>
  </div>
</template>

<script>
  import { mapState } from 'vuex'
  import { get } from 'lodash'

  import ReputationAndControl from './ReputationAndControl'
  import Projects from './Projects'
  import TeamMoney from './TeamMoney'
  import Suspicions from './Suspicions'

  import Avatar from '../../BladeInTheDarck/sheets/Avatar'
  import { BiD } from '../../../../../lib/BiD'
  import { UPDATE_SHEET_NAME, UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'

  export default {
    name: 'TeamMainBody',
    components: { Suspicions, TeamMoney, Projects, ReputationAndControl, Avatar },
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
          this.$store.commit(UPDATE_SHEET_NAME, { id: this.sheet.id, name })
        },
      },

      reputation: {
        get() {
          return this.params.info.reputation
        },
        set(value) {
          this.input('reputation', value)
        },
      },

      den: {
        get() {
          return this.params.info.den
        },
        set(value) {
          this.input('den', value)
        },
      },

      notes: {
        get() {
          return this.sheet.params.info.notes
        },

        set(value) {
          this.input('notes', value)
        },
      },

      role: {
        get() {
          return this.params.info.role
        },

        set(value) {
          this.changeRole(value)
          this.saveSheet()
        },
      },

      additionalFields: {
        get() {
          return this.params.info.additionalFields
        },
      },

      roles: {
        get() {
          const list = []
          const raw = this.tables.teamRoles
          for (const item in raw) {
            list.push({ value: item, text: raw[item].name })
          }

          return list
        },
      },
    },

    created() {
      if (this.params.info.role === '@random') {
        this.changeRole(BiD.randomRole(this.roles).value)
        this.saveSheet()
      }
    },

    methods: {
      changeRole(roleName) {
        this.input('role', roleName)
        this.changeAdditionalFields(roleName)
        this.changeProjects(roleName)
      },

      changeAdditionalFields(roleName) {
        const value = get(this.tables.teamRoles[roleName], 'additionalFields', [])
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `info.additionalFields`,
                             value,
                           })
      },

      changeProjects(roleName) {
        const value = get(this.tables.projects, roleName, [])
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'projects',
                             value,
                           })
      },

      input(target, value) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `info.${target}`,
                             value: value,
                           })

      },

      changeAdditionalField(value, index) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `info.additionalFields[${index}].current`,
                             value,
                           })

        this.saveSheet()
      },

      saveSheet() {
        this.$store.dispatch('saveSheet', this.sheet)
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .bgw {
    background: $white;
  }

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
    grid-template-columns: 1fr;
    grid-template-rows: auto;
    margin-left: 5px;
  }

  .main-row1-col2 {
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: auto auto;
    grid-gap: 5px 1vw;
    margin-left: 15px;
    margin-right: 15px;
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
    grid-template-areas:
    'role role'
    'name reputation';

    .role {
      grid-area: role;
    }

    .name {
      grid-area: name;
    }

    .reputation {
      grid-area: reputation;
    }
  }

  .grid-money-suspicions {
    display: grid;
    grid-template-columns: 1fr 1fr;
  }

  .notes {
    margin-right: 15px;
  }

  .footer {
    width: 100%;
    height: 5px;
  }
</style>
