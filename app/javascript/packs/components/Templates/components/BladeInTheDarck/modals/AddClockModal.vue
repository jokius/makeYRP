<template>
  <v-dialog :value="obj.open" max-width="600" persistent>
    <v-card>
      <v-card-title class="headline grey lighten-2" primary-title>
        Создать счетчик
      </v-card-title>
      <v-container class="fill-height" fluid>
        <v-row align="center" justify="center">
          <v-col cols="12">
            <v-text-field
              v-model="title"
              color="indigo"
              label="Название"
            />
          </v-col>
          <v-col cols="12">
            <v-select
              v-model="counter"
              :items="counters"
              color="indigo"
              label="Количество частей"
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
          @click="add"
        >
          Добавить
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
  export default {
    name: 'AddClockModal',

    model: {
      prop: 'obj',
      event: 'completed',
    },

    props: {
      obj: { type: Object, required: true },
    },

    data() {
      return {
        title: null,
        counter: 4,
        counters: [
          { text: 4, value: 4 },
          { text: 6, value: 6 },
          { text: 8, value: 8 },
        ],
      }
    },

    methods: {
      add() {
        this.$emit('completed', { open: false, clock: { title: this.title, counter: this.counter } })
        this.title = null
        this.counter = 4
      },

      close() {
        this.$emit('completed', { open: false, clock: {} })
        this.title = null
        this.counter = 4
      },
    },
  }
</script>
