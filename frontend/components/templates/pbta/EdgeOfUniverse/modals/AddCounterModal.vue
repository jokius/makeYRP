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
    name: 'AddCounterModal',

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
      }
    },

    methods: {
      add() {
        this.$emit('completed', { open: false, counter: { title: this.title } })
        this.title = null
      },

      close() {
        this.$emit('completed', { open: false, counter: {} })
        this.title = null
      },
    },
  }
</script>
