<template>
  <div class="sheet-body" :style="{ width, height }">
    <div class="main-row">
      <div class="main-row-col1">
        <avatar :sheet="sheet" />
        <v-text-field
          v-model="name"
          label="Имя"
          color="indigo"
          class="name"
          flat
          @change="saveSheet"
        />
      </div>
      <div class="main-row-col2">
        <v-select
          :value="role.key"
          :items="tableRoles"
          label="Архетип"
          class="role"
          color="indigo"
          @change="(value) => role = value"
        />
        <p class="role-examples">{{ role.examples }}</p>
        <ul>
          <li v-for="(move, index) in moves" :key="`move-${index}`">
            {{ move }}
          </li>
        </ul>
      </div>
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
</template>

<script>
  import { mapState } from 'vuex'

  import Avatar from './Avatar'
  import { Pbta } from '../../../../../lib/Pbta'

  export default {
    name: 'MonsterSheet',
    components: { Avatar },
    props: {
      id: { type: Number, required: true },
      size: { type: Object, required: true },
    },

    data() {
      return {
        tab: null,
      }
    },

    computed: {
      ...mapState({
        sheets: state => state.game.sheets,
        tables: state => state.game.info.template.tables,
      }),

      width: {
        get() {
          const width = this.size.width
          return typeof width === 'number' ? `${width}px` : width
        },
      },

      height: {
        get() {
          const height = this.size.height
          return typeof height === 'number' ? `${height}px` : height
        },
      },

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

      moves: {
        get() {
          return this.sheet.params.moves
        },
      },

      roles: {
        get() {
          return this.tables.monstersRoles
        },
      },

      tableRoles: {
        get() {
          return this.tables.monstersRoles.map(item => (
            { value: item.key, text: `${item.group}: ${item.name}` }
          ))
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

      name: {
        get() {
          return this.sheet.name
        },
        set(name) {
          this.$store.commit('game/updateSheetParams', { id: this.sheet.id, name })
        },
      },

      notes: {
        get() {
          return this.sheet.params.notes
        },

        set(value) {
          this.input('notes', value)
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
        const role = this.tables.monstersRoles.find(item => item.key === roleName)
        this.input('role', role)
        this.changeMoves(roleName)
      },

      changeMoves(role) {
        const roleMoves = this.tables.monstersMoves[role] || []
        this.$store.commit('game/updateSheetParams',
                           {
                             id: this.sheet.id,
                             path: 'moves',
                             value: roleMoves,
                           })
      },

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
    },
  }
</script>

<style scoped lang="scss">
  @import '~assets/css/colors';

  .sheet-body {
    background-color: $grayC5;
    overflow: auto;
  }

  .main-row {
    display: grid;
    grid-template-columns: 200px 0.99fr;
    grid-template-rows: max-content;
    grid-column-gap: 10px;
  }

  .role-examples {
    font-weight: bold;
    font-style: italic;
  }
</style>
