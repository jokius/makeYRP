<template>
  <draggable-dialog
    v-model="size"
    :on-close="onClose"
    :title="contentTitle"
    :width="size.width"
    :height="size.height"
    :disable-actions="isEdit"
    resizable
  >
    <template v-slot:body>
      <div v-if="isEdit">
        <v-text-field
          v-model="contentTitle"
          required
          color="indigo"
          label="Название"
        />
        <wysiwyg
          v-model="content"
          :options="{ maxHeight: `${size.height - editorOffsetH}px` }"
          :style="{ width, height, minWidth }"
        />
      </div>
      <div
        v-else
        :style="{ width, height, minWidth }"
        v-html="content"
      />
    </template>
    <template v-slot:actions>
      <v-btn
        dark
        color="indigo"
        @click="onClose"
      >
        Закарыть
      </v-btn>

      <v-spacer />

      <v-btn
        dark
        color="indigo"
        @click="change"
      >
        {{ isNew ? 'Добавить': 'Изменить' }}
      </v-btn>
    </template>
  </draggable-dialog>
</template>

<script>

  import DraggableDialog from './DraggableDialog'

  import { REMOVE_OPEN_MODAL } from '../../stores/mutation-types'
  export default {
    name: 'NoteModal',
    components: { DraggableDialog },

    props: {
      id: { type: Number, required: true },
      uniqKey: { type: Number, required: true },
      title: { type: String, default: null },
      text: { type: String, default: null },
      isEdit: { type: Boolean, required: true },
      isNew: { type: Boolean, required: true },
    },

    data() {
      return {
        privateTitle: this.title || 'Новая заметка',
        privateText: this.text,
        minWidth: '516px',
        privateWidth: 516,
        privateHeight: 450,
        editorOffsetH: 217,
        bodyOffsetH: 177,
      }
    },

    computed: {
      contentTitle: {
        get() {
          return this.privateTitle
        },

        set(value) {
          this.privateTitle = value
        },
      },

      content: {
        get() {
          return this.privateText
        },

        set(value) {
          this.privateText = value
        },
      },

      size: {
        get() {
          return { width: this.privateWidth, height: this.privateHeight }
        },

        set({ width, height }) {
          this.privateWidth = width
          this.privateHeight = height
        },
      },

      width: {
        get() {
          const width = this.size.width
          return typeof width === 'number' ? `${width}px` : width
        },
      },

      height: {
        get() {
          const height = this.size.height
          return typeof height === 'number' ? `${height - this.bodyOffsetH}px` : `calc(${height} - 112px)`
        },
      },
    },

    methods: {
      change() {
        if (this.isNew) {
          this.$store.dispatch('createMenuItem',
                               { menu_id: this.id,  params: { title: this.contentTitle, text: this.content } })
        } else {
          this.$store.dispatch('updateMenuItem',
                               { id: this.id,  params: { title: this.contentTitle, text: this.content } })
        }

        this.onClose()
      },

      onClose() {
        this.$store.commit(REMOVE_OPEN_MODAL, this.uniqKey)
      },
    },
  }
</script>

<style scoped lang="scss">
  @import "~vue-wysiwyg/dist/vueWysiwyg.css";
</style>
