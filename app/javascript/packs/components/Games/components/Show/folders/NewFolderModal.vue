<template>
  <v-dialog :value="openDialog" width="300" persistent>
    <v-card>
      <v-card-title class="headline grey lighten-2" primary-title>
        Новая папка
      </v-card-title>
      <v-container class="fill-height" fluid>
        <v-row align="center" justify="center">
          <v-col cols="12">
            <v-form>
              <v-text-field
                v-model="name"
                required
                color="indigo"
                label="Название"
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
          @click="createFolder"
        >
          <span :class="{ whiteText: isValid }">Создать</span>
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
  import { mapState } from 'vuex'

  export default {
    name: 'NewFolderModal',
    model: {
      prop: 'openDialog',
      event: 'open',
    },

    props: {
      openDialog: { type: Boolean, default: false },
      parentId: { type: Number, default: null },
    },

    data() {
      return {
        newFolderName: null,
      }
    },

    computed: {
      ...mapState({
        folder: state => state.game.folder,
        foldersLoaded: state => state.game.foldersLoaded,
      }),

      isValid() {
        return this.name && this.name !== ''
      },

      name: {
        get() {
          return this.newFolderName
        },
        set(value) {
          this.newFolderName = value
        },
      },
    },

    methods: {
      close() {
        this.$emit('open', false)
      },

      createFolder() {
        this.close()
        this.$store.dispatch('createFolder', { parent_id: this.parentId, name: this.name })
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

