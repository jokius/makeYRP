<template>
  <v-dialog :value="obj.open" max-width="300" persistent>
    <v-card>
      <v-card-title class="headline grey lighten-2" primary-title>
        Добавить тег
      </v-card-title>
      <v-container class="fill-height" fluid>
        <v-row align="center" justify="center">
          <v-col cols="12">
            <v-text-field
              v-model="tag"
              color="indigo"
              flat
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
          Добавить
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
  export default {
    name: 'AddTagModal',

    model: {
      prop: 'obj',
      event: 'addTag',
    },

    props: {
      obj: { type: Object, required: true },
    },

    data() {
      return {
        tag: '',
      }
    },

    methods: {
      roll() {
        this.$emit('addTag', { open: false, tag: this.tag })
        this.tag = ''
      },

      close() {
        this.$emit('addTag', { open: false, tag: this.tag })
        this.tag = ''
      },
    },
  }
</script>
