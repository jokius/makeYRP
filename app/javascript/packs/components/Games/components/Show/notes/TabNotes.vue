<template>
  <div>
    <div class="grid">
      <v-btn
        class="selectButton"
        color="indigo"
        tile
        dark
        @click="showModal"
      >
        Добавить заметку
      </v-btn>
      <notes-list :list="menu.items" />
    </div>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import NotesList from './NotesList'

  import { ADD_OPEN_MODAL, RESET_MARKER } from '../../../stores/mutation-types'
  import { ItemMenuModel } from '../../../../../models/ItemMenuModel'

  export default {
    name: 'TabNotes',
    components: { NotesList },

    computed: {
      ...mapState({
        menus: state => state.game.info.menus,
      }),

      menu: {
        get() {
          return this.menus.find(item => item.type === 'notes')
        },
      },
    },

    activated() {
      this.$store.commit(RESET_MARKER, 'notes')
    },

    methods: {
      showModal() {
        const key = Date.now()
        const note = new ItemMenuModel()
        note.menuId = this.menu.id
        this.$store.commit(ADD_OPEN_MODAL, {
          name: 'note',
          key,
          isNew: true,
          isEdit: true,
          note: note,
        })
      },
    },
  }
</script>

<style scoped lang="scss">
  .grid {
    display: grid;
    grid-template-columns: 1fr;
    grid-auto-rows: auto;
    grid-row-gap: 5px;
  }

  .selectButton {
    margin: 0;
    width: auto;
  }
</style>
