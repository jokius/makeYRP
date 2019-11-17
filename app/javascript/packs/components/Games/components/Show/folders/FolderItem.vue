<template>
  <right-click-menu :position="position" :current-obj="item">
    <v-btn
      height="100%"
      width="100%"
      class="folder"
      color="indigo"
      text
      @click="openFolder(id)"
      @contextmenu="handler($event)"
    >
      <span class="content">
        <v-icon size="80">mdi-folder-image</v-icon>
        <span class="text">{{ name }}</span>
      </span>
    </v-btn>
  </right-click-menu>
</template>

<script>
  import { mapState } from 'vuex'

  import RightClickMenu from '../RightClickMenu'
  import { mousePosition } from '../../../../../lib/mousePosition'
  import { UPDATE_CURRENT_RIGHT_CLICK_MENU } from '../../../stores/mutation-types'

  export default {
    name: 'FolderItem',
    components: { RightClickMenu },
    props: {
      id: { type: Number, required: true },
      name: { type: String, required: true },
    },

    data: () => ({
      showMenu: false,
      showRenameModal: false,
      position: {
        x: 0,
        y: 0,
      },
    }),

    computed: {
      ...mapState({
        currentRightClickMenu: (state) => state.game.currentRightClickMenu,
      }),

      item: {
        get() {
          return {
            type: 'folder',
            id: this.id,
          }
        },
      },

      renameFolder: {
        get() {
          return true
        },
        set() {
          this.showRenameModal = true
        },
      },
    },

    methods: {
      handler(e) {
        this.position = mousePosition(e)
        this.$store.commit(UPDATE_CURRENT_RIGHT_CLICK_MENU, `folder-${this.id}`)
        e.preventDefault()
      },

      openFolder(id) {
        this.$store.dispatch('loadFolder', { id })
      },
    },
  }
</script>

<style scoped lang="scss">
  .v-btn {
    text-transform: none;
  }

  .content {
    display: flex;
    flex-direction: column;
  }

  .text {
    width: 150px;
    white-space: normal;
  }
</style>
