<template>
  <v-dialog :value="obj.open" max-width="600" persistent>
    <v-card>
      <v-card-title class="headline grey lighten-2" primary-title>
        Выбрать травму
      </v-card-title>
      <v-container class="fill-height" fluid>
        <v-row align="center" justify="center">
          <v-col cols="12">
            <v-select
              v-model="injury"
              :items="injuries"
              color="indigo"
              label="Травма"
            />
          </v-col>
          <v-col cols="12">
            <span v-html="injury.description" />
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
  import { differenceBy } from 'lodash'

  export default {
    name: 'AddInjuryModal',

    model: {
      prop: 'obj',
      event: 'completed',
    },

    props: {
      obj: { type: Object, required: true },
      currentInjuries: { type: Array, required: true },
    },

    data() {
      return {
        injury: {},
      }
    },

    computed: {
      ...mapState({
        tables: state => state.game.info.template.tables,
      }),

      injuries: {
        get() {
          const list = differenceBy(this.tables.injuries, this.currentInjuries, 'name')
          return list.map(item => ({ text: item.name, value: item }))
        },
      },
    },

    methods: {
      add() {
        this.$emit('completed', { open: false, injury: this.injury })
        this.injury = {}
      },

      close() {
        this.$emit('completed', { open: false, injury: {} })
        this.injury = {}
      },
    },
  }
</script>
