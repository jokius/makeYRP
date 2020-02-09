<template>
  <div class="grid">
    <div class="grid-title">
      <span class="title">Навыки</span>
      <v-icon class="dice">mdi-radioactive</v-icon>
    </div>
    <div class="grid-body">
      <div
        v-for="(item, index) in skills"
        :key="item.target"
        class="grid-item"
      >
        <span class="text">{{ item.name }}</span>
        <span class="text align-r border-r">{{ item.state }}</span>
        <input
          :value="item.current"
          class="input border-r"
          type="number"
          :min="item.min"
          :max="item.max"
          @input="event => change(index, event.target.value)"
        />
        <div class="actions">
          <v-btn
            icon
            @click="showInfo(item)"
          >
            <v-icon>mdi-notebook</v-icon>
          </v-btn>
          <v-btn
            v-if="item.removable"
            color="red darken-4"
            icon
            dark
            @click="remove(index)"
          >
            <v-icon>mdi-delete</v-icon>
          </v-btn>
        </div>
      </div>
    </div>

    <v-btn @click="addRoleSkill">
      Добавить навык роли
    </v-btn>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import { ADD_OPEN_MODAL, UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'
  import { Myz } from '../../../../../lib/Myz'

  export default {
    name: 'Skills',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      ...mapState({
        tables: state => state.game.info.template.tables,
      }),

      skills: {
        get() {
          return this.sheet.params.skills
        },
      },
    },

    methods: {
      change(target, value) {
        const intVal = parseInt(value, 10) || value
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `skills.${target}.current`,
                             value: intVal,
                           })

        if (value && value !== '')
          this.$store.dispatch('saveSheet', this.sheet)
      },

      remove(index) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'skills',
                             value: index,
                             remove: true,
                           })

        this.$store.dispatch('saveSheet', this.sheet)
      },

      showInfo({ name, notes }) {
        const key = Date.now()
        this.$store.commit(ADD_OPEN_MODAL, { name: 'info', key, title: name, description: notes })
      },

      addRoleSkill() {
        const raw = this.tables.skills[this.sheet.params.info.role]
        if (!raw) return

        const skill = Myz.addSkill(raw)

        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `skills.${this.skills.length}`,
                             value: skill,
                           })

        this.$store.dispatch('saveSheet', this.sheet)
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  $title_height: 35px;

  .grid {
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: $title_height max-content;
  }

  .grid-title {
    display: grid;
    grid-template-columns: 1fr max-content;
    background-image: url("../images/skills.jpeg");
    background-size: cover;
    background-color: $orangeE9;
  }

  .grid-body {
    display: grid;
    grid-template-columns: 1fr;
    padding-left: 5px;
    padding-bottom: 3px;
  }

  .grid-item {
    display: grid;
    grid-template-columns: 1fr 1fr 50px 80px;
    grid-template-rows: $title_height;
    border: 1px solid $black;
  }

  .border-r {
    border-right: 1px solid $black;
  }

  .title {
    font-size: 2.5rem;
    font-weight: bold;
    color: $white;
    padding-left: 5px;
    vertical-align: middle;
    line-height: $title_height;
  }

  .align-r {
    text-align: end;
  }

  .text {
    padding-right: 5px;
    vertical-align: middle;
    line-height: $title_height;
  }

  .dice {
    margin-top: 3px;
    width: 30px;
    height: 30px;
    background-color: green;
    border-radius: 8px;
    color: $black;
  }

  .input {
    padding: 0;
    margin: 0;
    background-color: $white;
    &:focus {
      outline: none !important;
      border: 2px solid $purple51;
      box-shadow: 0 0 10px $purple51;
    }
  }
</style>
