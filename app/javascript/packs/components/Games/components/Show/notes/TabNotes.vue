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

  import { ADD_OPEN_MODAL } from '../../../stores/mutation-types'

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

    methods: {
      showModal() {
        const key = Date.now()
        this.$store.commit(ADD_OPEN_MODAL, { name: 'note', key, id: this.menu.id, isNew: true, isEdit: true })
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
