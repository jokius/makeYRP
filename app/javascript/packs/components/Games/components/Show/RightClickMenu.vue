<template>
  <div>
    <v-menu
      v-model="show"
      absolute
      :position-x="position.x"
      :position-y="position.y"
    >
      <template v-slot:activator="{ on }">
        <slot v-on="on" />
      </template>
      <v-list>
        <v-list-item
          v-for="(item, index) in items"
          :key="index"
          @click="item.callback"
        >
          <v-list-item-title>{{ item.title }}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-menu>

    <rename-modal
      v-if="renameModal"
      v-model="renameModal"
      :obj="currentObj"
    />
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import RenameModal from './RenameModal'

  import { UPDATE_CURRENT_RIGHT_CLICK_MENU } from '../../stores/mutation-types'

  export default {
    name: 'RightClickMenu',
    components: { RenameModal },

    props: {
      position: { type: Object, required: true },
      currentObj: { type: Object, required: true },
    },

    data() {
      return {
        renameModal: false,
      }
    },

    computed: {
      ...mapState({
        currentRightClickMenu: state => state.game.currentRightClickMenu,
      }),

      show: {
        get() {
          return this.currentRightClickMenu === `${this.currentObj.type}-${this.currentObj.id}`
        },
        set() {
          this.$store.commit(UPDATE_CURRENT_RIGHT_CLICK_MENU, '')
        },
      },

      items: {
        get() {
          return [
            { title: 'Переименовать', callback: () => this.showRename() },
            { title: 'Удалить', callback: () => this.$store.dispatch('removeObj', this.currentObj) },
          ]
        },
      },
    },

    methods: {
      showRename() {
        this.renameModal = true
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .main {
    background-color: $gray52;
  }

  .select {
    background-color: $purple51;
  }

  .buttonGroup {
    height: 55px;
    margin-right: 2px;
  }
</style>
