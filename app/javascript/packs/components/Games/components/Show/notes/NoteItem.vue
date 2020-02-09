<template>
  <v-list-item class="clock-item-grid">
    <span>{{ note.params.title }}</span>
    <v-btn
      fab
      x-small
      dark
      @click="viewNote"
    >
      <v-icon>mdi-eye-outline</v-icon>
    </v-btn>
    <v-btn
      fab
      x-small
      dark
      @click="editNote"
    >
      <v-icon>mdi-pencil</v-icon>
    </v-btn>
    <v-btn
      color="red darken-4"
      fab
      x-small
      dark
      @click="deleteNote"
    >
      <v-icon>mdi-delete</v-icon>
    </v-btn>
  </v-list-item>
</template>

<script>
  import { ADD_OPEN_MODAL, DELETE_MENU_ITEM, UPDATE_MENU_ITEM } from '../../../../Games/stores/mutation-types'

  export default {
    name: 'NoteItem',
    props: {
      note: { type: Object, required: true },
    },

    data() {
      return {
        privateObj: { open: this.modalOpen, edit: true, note: this.note.params },
      }
    },

    channels: {
      MenusItemChannel: {
        received(obj) {
          if (obj.delete) {
            this.$cable.unsubscribe('MenusItemChannel')
            this.$store.commit(DELETE_MENU_ITEM, obj.delete)
          } else {
            this.$store.commit(UPDATE_MENU_ITEM, obj)
          }
        },
      },
    },

    computed: {
      obj: {
        get() {
          return this.privateObj
        },

        set({ open, note }) {
          if (note) {
            this.editItem(note)
          }

          this.privateObj.modalOpen = open
        },
      },
    },

    mounted() {
      this.$cable.subscribe({
        channel: 'MenusItemChannel',
        id: this.note.id,
      })
    },

    methods: {
      viewNote() {
        this.showModal(false)
      },

      editNote() {
        this.showModal(true)
      },

      showModal(isEdit) {
        const key = Date.now()
        this.$store.commit(ADD_OPEN_MODAL,
                           { name: 'note', key, id: this.note.id, isNew: false, isEdit: isEdit, ...this.note.params })
      },

      deleteNote() {
        this.$store.dispatch('deleteMenuItem', this.note.id)
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .clock-item-grid {
    display: grid;
    grid-template-columns: 1fr max-content max-content max-content;
    grid-column-gap: 5px;
    justify-items: center;
    align-items: center;
  }
</style>
