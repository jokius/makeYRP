<template>
  <v-dialog :value="obj.open" max-width="300" persistent>
    <v-card>
      <v-card-title class="headline grey lighten-2" primary-title>
        Количество кубиков
      </v-card-title>
      <v-container class="fill-height" fluid>
        <v-row align="center" justify="center">
          <v-col cols="12">
            <v-text-field
              v-model.number="dices"
              color="indigo"
              type="number"
              flat
              min="0"
            />
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
          @click="roll"
        >
          Бросить
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
  export default {
    name: 'RollDamageModal',

    model: {
      prop: 'obj',
      event: 'roll',
    },

    props: {
      obj: { type: Object, required: true },
    },

    data() {
      return {
        dices: 1,
      }
    },

    methods: {
      roll() {
        this.$emit('roll', { open: false, dices: this.dices })
        this.dices = 1
      },

      close() {
        this.$emit('roll', { open: false, dices: 0, isClose: true })
        this.dices = 1
      },
    },
  }
</script>
