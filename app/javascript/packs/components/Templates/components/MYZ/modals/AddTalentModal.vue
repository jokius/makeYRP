<template>
  <v-dialog :value="obj.open" max-width="600" persistent>
    <v-card>
      <v-card-title class="headline grey lighten-2" primary-title>
        Выбрать достоинство
      </v-card-title>
      <v-container class="fill-height" fluid>
        <v-row align="center" justify="center">
          <v-col cols="12">
            <v-select
              v-model="talent"
              :items="talents"
              color="indigo"
              label="достоинство"
            />
          </v-col>
          <v-col cols="12">
            <span v-html="talent.description" />
          </v-col>
        </v-row>
      </v-container>

      <v-divider />

      <v-card-actions>
        <v-btn
          dark
          color="indigo"
          @click="add"
        >
          Добавить
        </v-btn>

        <v-spacer />

        <v-btn
          dark
          color="indigo"
          @click="close"
        >
          Закарыть
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
  import { mapState } from 'vuex'

  export default {
    name: 'AddTalentModal',

    model: {
      prop: 'obj',
      event: 'completed',
    },

    props: {
      obj: { type: Object, required: true },
      role: { type: String, required: true },
    },

    data() {
      return {
        talent: {},
      }
    },

    computed: {
      ...mapState({
        tables: state => state.game.info.template.tables,
      }),

      talents: {
        get() {
          let list = [{ text: 'Навыки роли', value: { all: false }, disabled: true }]
          list = list.concat(this.rolesToSelect(this.tables.talents[this.role] || []))
          list.push({ text: 'Общие навыки', value: { all: true }, disabled: true })
          return list.concat(this.rolesToSelect(this.tables.talents.all || []))
        },
      },
    },

    methods: {
      rolesToSelect(roles) {
        return roles.map(item => ({ text: item.name, value: item }))
      },

      add() {
        this.$emit('completed', { open: false, talent: this.talent })
        this.talent = {}
      },

      close() {
        this.$emit('completed', { open: false, talent: {} })
        this.talent = {}
      },
    },
  }
</script>
