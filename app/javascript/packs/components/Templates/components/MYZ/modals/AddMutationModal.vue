<template>
  <v-dialog :value="obj.open" max-width="400" persistent>
    <v-card>
      <v-card-title class="headline grey lighten-2" primary-title>
        Задать мутацию вручную
      </v-card-title>
      <v-container class="fill-height" fluid>
        <v-row align="center" justify="center">
          <v-col cols="12">
            <v-select
              v-model="selectKey"
              :items="mutations.map((item) => ({ text: item.name, value: item.key }))"
              color="indigo"
              label="по названию"
            />
          </v-col>
          <v-col cols="12">
            <v-text-field
              v-model="selectKey"
              required
              color="indigo"
              type="number"
              label="по номеру"
            />
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

  import { Myz } from '../../../../../lib/Myz'

  export default {
    name: 'AddMutationModal',

    model: {
      prop: 'obj',
      event: 'completed',
    },

    props: {
      obj: { type: Object, required: true },
    },

    data() {
      return {
        mutation: {},
      }
    },

    computed: {
      ...mapState({
        tables: state => state.game.info.template.tables,
      }),

      mutations: {
        get() {
          return this.tables.mutations
        },
      },

      selectKey: {
        get() {
          return this.mutation.key
        },
        set(key) {
          this.setMutation(key)
        },
      },
    },

    methods: {
      setMutation(key) {
        if (key.length < 2) return {}

        this.mutation = Myz.getMutationByKey(this.mutations, key) || {}
      },

      add() {
        this.$emit('completed', { open: false, mutation: this.mutation })
        this.mutation = {}
      },

      close() {
        this.$emit('completed', { open: false, mutation: {} })
        this.mutation = {}
      },
    },
  }
</script>
