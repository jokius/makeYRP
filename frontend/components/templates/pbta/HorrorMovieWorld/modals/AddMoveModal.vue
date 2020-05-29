<template>
  <v-dialog :value="obj.open" max-width="600" persistent>
    <v-card>
      <v-card-title class="headline grey lighten-2" primary-title>
        Выбрать ход
      </v-card-title>
      <v-container class="fill-height" fluid>
        <v-row align="center" justify="center">
          <v-col cols="12">
            <v-select
              v-model="move"
              :items="selectList"
              color="indigo"
              label="Ход"
            />
          </v-col>
          <v-col cols="12">
            <span v-html="move.description" />
          </v-col>
        </v-row>
      </v-container>

      <v-divider />

      <v-card-actions>
        <v-btn
          dark
          color="indigo"
          @click="close"
        >
          Закарыть
        </v-btn>
        <v-spacer />
        <v-btn
          dark
          :disabled="!move.name"
          color="indigo"
          @click="add"
        >
          Добавить
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
  import { mapState } from 'vuex'

  export default {
    name: 'AddMoveModal',

    model: {
      prop: 'obj',
      event: 'completed',
    },

    props: {
      obj: { type: Object, required: true },
      role: { type: Object, required: true },
      moves: { type: Array, required: true },
    },

    data() {
      return {
        move: {},
      }
    },

    computed: {
      ...mapState({
        tables: state => state.game.info.template.tables,
      }),

      selectList: {
        get() {
          let list = []
          for (let key in this.tables.moves) {
            if (this.role.key !== key) {
              const name = this.tables.roles.find(item => item.key === key).name
              list.push({ text: name, value: false, disabled: true })
              list = list.concat(this.roleMoves(this.tables.moves[key]))
            }
          }

          return list
        },
      },
    },

    methods: {
      roleMoves(list) {
        return list.map(item => {
          if (this.moves.find(move => move.name === item.name)) return
          const value = item
          value.remove = true

          return {
            text: item.name,
            value,
          }
        }).filter(Boolean)
      },

      add() {
        this.$emit('completed', { open: false, move: this.move })
        this.move = {}
      },

      close() {
        this.$emit('completed', { open: false, move: {} })
        this.move = {}
      },
    },
  }
</script>
