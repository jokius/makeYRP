<template>
  <draggable-dialog
    v-model="size"
    :on-close="onClose"
    :title="title"
    :width="size.width"
    :height="size.height"
    :disable-actions="!isEdit"
    resizable
  >
    <template v-slot:body>
      <div v-if="isEdit">
        <v-text-field
          v-model="title"
          required
          color="indigo"
          label="Название"
        />
        <wysiwyg
          v-model="text"
          :options="{ maxHeight: `${size.height - editorOffsetH}px` }"
          :style="{ width, height, minWidth }"
        />
      </div>
      <div
        v-else
        :style="{ width, height, minWidth }"
        v-html="text"
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

  import { REMOVE_OPEN_MODAL, UPDATE_MENU_ITEM_PARAMS } from '../../stores/mutation-types'
  export default {
    name: 'NoteModal',
    components: { DraggableDialog },

    props: {
      note: { type: Object, required: true },
      uniqKey: { type: Number, required: true },
      isEdit: { type: Boolean, required: true },
      isNew: { type: Boolean, required: true },
    },

    data() {
      return {
        privateTitle: 'Новая заметка',
        privateText: '',
        minWidth: '516px',
        privateWidth: 516,
        privateHeight: 450,
        editorOffsetH: 217,
        bodyOffsetH: 177,
      }
    },

    computed: {
      title: {
        get() {
          return this.note.params.title || this.privateTitle
        },

        set(value) {
          if (this.isNew) {
            this.privateTitle = value
          } else {
            this.input('title', value)
          }
        },
      },

      text: {
        get() {
          return this.note.params.text || this.privateText
        },

        set(value) {
          if (this.isNew) {
            this.privateText = value
          } else {
            this.input('text', value)
          }
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
      input(path, value) {
        this.$store.commit(UPDATE_MENU_ITEM_PARAMS, {
          id: this.note.id,
          menuId: this.note.menuId,
          path,
          value,
        })
      },

      change() {
        if (this.isNew) {
          this.$cable.perform({
            channel: 'GameChannel',
            action: 'add',
            data: {
              menu_id: this.note.menuId,
              params: { title: this.privateTitle, text: this.privateText },
              type: 'menu_item',
            },
          })
        } else {
          this.$cable.perform({
            channel: 'GameChannel',
            action: 'change',
            data: { ...this.note, type: 'menu_item' },
          })
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
