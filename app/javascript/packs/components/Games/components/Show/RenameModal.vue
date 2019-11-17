<template>
  <v-dialog :value="openDialog" width="300">
    <v-card>
      <v-card-title class="headline grey lighten-2" primary-title>
        Переименовать
      </v-card-title>
      <v-container class="fill-height" fluid>
        <v-row align="center" justify="center">
          <v-col cols="12">
            <v-form>
              <v-text-field
                v-model="name"
                required
                color="indigo"
                label="Новое название"
              />
            </v-form>
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
          :disabled="!isValid"
          color="indigo"
          @click="rename"
        >
          <span :class="{ whiteText: isValid }">Переименовать</span>
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
  export default {
    name: 'RenameModal',
    model: {
      prop: 'openDialog',
      event: 'open',
    },

    props: {
      openDialog: { type: Boolean, default: false },
      obj: { type: Object, required: true },
    },

    data() {
      return {
        newObjName: null,
      }
    },

    computed: {
      isValid() {
        return this.name && this.name !== ''
      },

      name: {
        get() {
          return this.newObjName
        },
        set(value) {
          this.newObjName = value
        },
      },
    },

    methods: {
      close() {
        this.$emit('open', false)
      },

      rename() {
        this.close()
        this.$store.dispatch('renameObj', { ...this.obj, name: this.name })
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .whiteText {
    color: $white;
  }
</style>

