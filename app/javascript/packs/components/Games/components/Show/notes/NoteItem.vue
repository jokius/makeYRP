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

  import { ADD_OPEN_MODAL } from '../../../stores/mutation-types'

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
                           {
                             name: 'note',
                             key,
                             isNew: false,
                             isEdit: isEdit,
                             note: this.note,
                           })
      },

      deleteNote() {
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'remove',
          data: { id: this.note.id, type: 'menu_item' },
        })
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
