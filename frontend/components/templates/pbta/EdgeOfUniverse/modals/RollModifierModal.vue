<template>
  <v-dialog :value="obj.open" max-width="300" persistent>
    <v-card>
      <v-card-title class="headline grey lighten-2" primary-title>
        Модификатор броска
      </v-card-title>
      <v-container class="fill-height" fluid>
        <v-row align="center" justify="center">
          <v-col cols="12">
            <v-select
              v-model="modifier"
              :items="modifiers"
              color="indigo"
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
          @click="modify"
        >
          Бросить
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
  export default {
    name: 'RollModifierModal',

    model: {
      prop: 'obj',
      event: 'roll',
    },

    props: {
      obj: { type: Object, required: true },
    },

    data() {
      return {
        modifiers: [-3, -2, -1, 0, 1, 2, 3, 10],
        modifier: 0,
      }
    },

    methods: {
      modify() {
        this.$emit('roll', { open: false, modifier: this.modifier })
        this.modifier = 0
      },

      close() {
        this.$emit('roll', { open: false, modifier: 0, isClose: true })
        this.modifier = 0
      },
    },
  }
</script>
