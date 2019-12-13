<template>
  <v-dialog
    :value="openDialog"
    width="710"
    scrollable
    persistent
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
          @click="$emit('close')"
        >
          Закрыть
        </v-btn>

        <v-spacer />

        <v-btn
          color="indigo"
          text
          @click="openDropzone = true"
        >
          Загрузить файлы
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
  import { get } from 'lodash'

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
      }
    },

    computed: {
      ...mapState({
        folder: (state) => state.game.folder,
        foldersLoaded: (state) => state.game.foldersLoaded,
        game: (state) => state.game.info,
        currentPage: (state) => state.game.currentPage,
        sheets: (state) => state.game.sheets,
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

      currentSelected: {
        get() {
          return this[this.targetObj.target]
        },
        set(value) {
          this[this.targetObj.target] = value
        },
      },

      page: {
        get() {
          return get(this.currentPage.params, 'background.image.id', 0)
        },
        set(value) {
          const image = this.currentSelected.page !== value.id ?  value : null
          this.$store.dispatch('changePage', { background: { image } })
        },
      },

      currentSheet: {
        get() {
          return this.sheets.find((sheet) => sheet.id === this.targetObj.id)
        },
      },

      sheet: {
        get() {
          return get(this.currentSheet.params, 'img.id', 0)
        },
        set(value) {
          const img = this.currentSheet.params.img || {}
          const image = img.id !== value.id ?  value : null
          this.$store.dispatch('changeSheet',
                               { sheet: this.currentSheet,
                                 changes: { params: { img: image } },
                               })
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
    margin-top: 10px;
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
