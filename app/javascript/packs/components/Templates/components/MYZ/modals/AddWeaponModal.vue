<template>
  <v-dialog :value="obj.open" max-width="600" persistent>
    <v-card>
      <v-card-title class="headline grey lighten-2" primary-title>
        Выбрать стандартное оружие
      </v-card-title>
      <v-container class="fill-height" fluid>
        <v-row align="center" justify="center">
          <v-col cols="12">
            <v-select
              v-model="weapon"
              :items="weapons"
              color="indigo"
              label="оружие"
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

  export default {
    name: 'AddWeaponModal',

    model: {
      prop: 'obj',
      event: 'completed',
    },

    props: {
      obj: { type: Object, required: true },
    },

    data() {
      return {
        weapon: {},
      }
    },

    computed: {
      ...mapState({
        tables: (state) => state.game.info.template.tables,
      }),

      weapons: {
        get() {
          return this.tables.weapons.map((item) => ({ text: item.name, value: item }))
        },
      },
    },

    methods: {
      add() {
        this.$emit('completed', { open: false, weapon: this.weapon })
        this.weapon = {}
      },

      close() {
        this.$emit('completed', { open: false, weapon: {} })
        this.weapon = {}
      },
    },
  }
</script>
