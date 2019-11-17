<template>
  <v-dialog :value="openDialog" width="500">
    <v-card>
      <v-card-title class="headline grey lighten-2" primary-title>
        Загрузить изображение
      </v-card-title>
      <v-container class="fill-height" fluid>
        <v-row align="center" justify="center">
          <v-col cols="12">
            <vue-dropzone
              id="dropzone"
              ref="imageDropzone"
              :options="dropzoneOptions"
              use-custom-slot
              @vdropzone-success="fileAdded"
            >
              <span class="content">
                <v-icon large>mdi-plus</v-icon>
                <span>Добавить изображение</span>
              </span>
            </vue-dropzone>
          </v-col>
        </v-row>
      </v-container>

      <v-divider />

      <v-card-actions>
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
  import VueDropzone from 'vue2-dropzone'
  import 'vue2-dropzone/dist/vue2Dropzone.min.css'

  import links from '../../../../../helpers/links'
  import headers from '../../../../../helpers/headers'
  import { FOLDERS_LOADED } from '../../../stores/mutation-types'

  export default {
    name: 'DropzoneModal',
    components: { VueDropzone },

    model: {
      prop: 'openDialog',
      event: 'open',
    },

    props: {
      openDialog: { type: Boolean, default: false },
      folderId: { type: Number, required: true },
    },

    computed: {
      dropzoneOptions() {
        return {
          headers,
          url: links.dynamic(links.base.folderImages, { folder_id: this.folderId }),
          acceptedFiles: 'image/*',
        }
      },
    },

    methods: {
      close() {
        this.$emit('open', false)
      },

      fileAdded(file, response) {
        this.$refs.imageDropzone.removeFile(file)
        this.$store.commit(FOLDERS_LOADED, response)
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .vue-dropzone {
    border: none;
  }

  .content {
    display: flex;
    flex-direction: column;
  }
</style>
