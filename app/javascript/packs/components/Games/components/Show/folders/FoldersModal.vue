<template>
  <v-dialog
    :value="openDialog"
    width="664"
    scrollable
  >
    <v-card>
      <v-card-title class="headline grey lighten-2" primary-title>
        {{ title }}
      </v-card-title>
      <folders-preloader v-if="!foldersLoaded" />
      <v-card-actions v-if="foldersLoaded">
        <v-btn
          v-if="parentId"
          color="indigo"
          text
          @click="previousFolder"
        >
          Назад
        </v-btn>
        <v-spacer />
        <v-btn
          color="indigo"
          text
          @click="openNewFolder = true"
        >
          Добавить папку
        </v-btn>
      </v-card-actions>

      <v-divider />

      <v-card-text v-if="foldersLoaded">
        <div class="grid">
          <folder-item
            v-for="child in children"
            :id="child.id"
            :key="'child_' + child.id"
            :name="child.name"
          />
          <image-item
            v-for="image in images"
            :key="'image_' + image.id"
            v-model="currentSelected"
            :image="image"
          />
        </div>
      </v-card-text>

      <v-divider />

      <v-card-actions v-if="foldersLoaded">
        <v-btn
          color="indigo"
          text
          @click="openDropzone = true"
        >
          Загрузить файлы
        </v-btn>

        <v-spacer />
        <v-btn
          color="indigo"
          text
          @click="$emit('close')"
        >
          Выбрать
        </v-btn>
      </v-card-actions>
    </v-card>

    <new-folder-modal
      v-if="openNewFolder"
      v-model="openNewFolder"
      :parent-id="parentId"
    />

    <dropzone-modal
      v-if="openDropzone"
      v-model="openDropzone"
      :folder-id="folder.id"
    />
  </v-dialog>
</template>

<script>
  import { mapState } from 'vuex'


  import FolderItem from './FolderItem'
  import FoldersPreloader from './FoldersPreloader'
  import NewFolderModal from './NewFolderModal'
  import ImageItem from './ImageItem'
  import DropzoneModal from './DropzoneModal'

  export default {
    name: 'FoldersModal',
    components: { DropzoneModal, FoldersPreloader, NewFolderModal, FolderItem, ImageItem },

    props: {
      targetObj: { type: Object, required: true },
      openDialog: { type: Boolean, required: true },
    },

    data() {
      return {
        openNewFolder: false,
        openDropzone: false,
        newFolderName: null,
        currentSelected: 0,
      }
    },

    computed: {
      ...mapState({
        folder: (state) => state.game.folder,
        foldersLoaded: (state) => state.game.foldersLoaded,
      }),

      title: {
        get() {
          return this.foldersLoaded ? this.folder.name : 'Загрузка...'
        },
      },

      parentId: {
        get() {
          return this.folder.parentId || null
        },
      },

      children: {
        get() {
          return this.folder.children
        },
      },

      images: {
        get() {
          return this.folder.images
        },
      },
    },

    created() {
      this.$store.dispatch('loadFolder', { id: this.folder.id })
    },

    methods: {
      previousFolder() {
        this.$store.dispatch('loadFolder', { parent_id: this.parentId })
      },
    },
  }
</script>

<style scoped lang="scss">
  .grid {
    display: grid;
    grid-template-columns: repeat(4, 150px);
    grid-template-rows: auto;
    grid-gap: 10px;
    margin-top: 7px;
    margin-bottom: 5px;
  }

  .loader {
    position: relative;
    top: 50%;
  }

  .dropZoneFull {
    width: 100%;
    border: 1px dashed black;
  }
</style>
