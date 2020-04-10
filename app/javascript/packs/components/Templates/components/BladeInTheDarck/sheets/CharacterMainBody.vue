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
            v-model="team"
            label="Команда"
            color="indigo"
            class="team"
            @change="saveSheet"
          />
          <v-text-field
            v-model="name"
            label="Кличка"
            color="indigo"
            class="name"
            flat
            @change="saveSheet"
          />
          <v-text-field
            v-model="realName"
            label="Имя"
            color="indigo"
            class="realName"
            @change="saveSheet"
          />
          <v-text-field
            v-model="appearance"
            label="Внешность"
            color="indigo"
            class="appearance"
            @change="saveSheet"
          />
        </div>
      </div>
    </div>
    <div class="main-row2">
      <v-text-field
        v-model="origin"
        label="Происхождение"
        :hint="origins"
        color="indigo"
        class="origin"
        @change="saveSheet"
      />
      <v-text-field
        v-model="past"
        label="Прошлое"
        :hint="pasts"
        color="indigo"
        class="past"
        @change="saveSheet"
      />
      <v-text-field
        v-model="passion"
        label="Страсть/Благодетель"
        :hint="passions"
        color="indigo"
        class="passion"
        @change="saveSheet"
      />
      <stress :sheet="sheet" />
      <damage-and-heal :sheet="sheet" />
      <v-textarea
        v-model="notes"
        auto-grow
        no-resize
        rows="2"
        color="indigo"
        class="input bgw"
        hide-details
        label="Заметки"
        @change="saveSheet"
      />
      <character-exp :sheet="sheet" />
    </div>
  </div>
</template>

<script>
  import { mapState } from 'vuex'
  import { get } from 'lodash'

  import Stress from './Stress'
  import DamageAndHeal from './DamageAndHeal'
  import CharacterExp from './CharacterExp'

  import { UPDATE_SHEET_NAME, UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'
  import { BiD } from '../../../../../lib/BiD'
  import Avatar from '../../BladeInTheDarck/sheets/Avatar'

  export default {
    name: 'CharacterMainBody',
    components: { CharacterExp, DamageAndHeal, Stress, Avatar },
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

      team: {
        get() {
          return this.params.info.team
        },
        set(value) {
          this.input('team', value)
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

      realName: {
        get() {
          return this.params.info.realName
        },
        set(value) {
          this.input('realName', value)
        },
      },

      appearance: {
        get() {
          return this.params.info.appearance
        },
        set(value) {
          this.input('appearance', value)
        },
      },

      origin: {
        get() {
          return this.params.info.origin
        },
        set(value) {
          this.input('origin', value)
        },
      },

      past: {
        get() {
          return this.params.info.past
        },
        set(value) {
          this.input('past', value)
        },
      },

      passion: {
        get() {
          return this.params.info.passion
        },
        set(value) {
          this.input('passion', value)
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

      notes: {
        get() {
          return this.sheet.params.info.notes
        },

        set(value) {
          this.input('notes', value)
        },
      },

      origins: {
        get() {
          return this.tables.origins.join(' - ')
        },
      },

      pasts: {
        get() {
          return this.tables.pasts.join(' - ')
        },
      },

      passions: {
        get() {
          return this.tables.passions.join(' - ')
        },
      },

      tableRoles: {
        get() {
          const list = []
          const raw = this.tables.roles
          for (const item in raw) {
            list.push({ value: item, text: raw[item].name })
          }

          return list
        },
      },

      roles: {
        get() {
          return [...this.tableRoles, { value: null, text: 'Свой ваниарт' }]
        },
      },
    },

    created() {
      if (this.params.info.role === '@random') {
        this.changeRole(BiD.randomRole(this.tableRoles).value)
        this.saveSheet()
      }
    },

    methods: {
      changeRole(roleName) {
        this.input('role', roleName)
        this.changeTalents(roleName)
        this.changeRelationship(roleName)
        this.changeAttributes(roleName)
        this.changeGear(roleName)
      },

      input(target, value) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `info.${target}`,
                             value: value,
                           })

      },

      changeTalents(role) {
        const list = this.params.talents.filter(talent => talent.enable)

        const roleTalents = this.tables.characterTalents[role] || []
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `talents`,
                             value: roleTalents.concat(list),
                           })
      },

      changeRelationship(role) {
        const list = this.params.relationship.filter(relation => relation.respect !== 0)

        const roleRelationship = this.tables.characterRelationship[role] || []
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `relationship`,
                             value: roleRelationship.concat(list),
                           })
      },

      // Find skill index by role skill name. Update skill value if current value lower.
      changeAttributes(roleName) {
        const skills = get(this.tables.roles[roleName], 'skills', null)
        if (!skills) return

        this.params.attributes.forEach((attribute, index) => {
          const attributeSkills = attribute.skills
          for (const key in skills) {
            const skillIndex = attributeSkills.findIndex(item => item.key === key)
            if (skillIndex > -1) {
              const value = skills[key]
              if (attributeSkills[skillIndex].current < value) {
                this.$store.commit(UPDATE_SHEET_PARAMS,
                                   {
                                     id: this.sheet.id,
                                     path: `attributes[${index}].skills[${skillIndex}].current`,
                                     value,
                                   })
              }
            }
          }
        })
      },

      changeGear(role) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `gear`,
                             value: this.tables.characterGear[role] || [],
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
    'team name'
    'realName appearance'
    'origin origin'
    'past past'
    'passion passion';

    .role {
      grid-area: role;
    }

    .team {
      grid-area: team;
    }

    .name {
      grid-area: name;
    }

    .appearance {
      grid-area: appearance;
    }

    .origin {
      grid-area: origin;
    }

    .past {
      grid-area: past;
    }

    .passion {
      grid-area: passion;
    }
  }
</style>
