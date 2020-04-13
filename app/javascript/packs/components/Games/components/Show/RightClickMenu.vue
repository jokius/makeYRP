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

    <access-modal
      v-if="accessModal"
      v-model="accessModal"
      :obj="currentObj"
    />
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import RenameModal from './RenameModal'
  import AccessModal from './AccessModal'

  import { UPDATE_CURRENT_RIGHT_CLICK_MENU } from '../../stores/mutation-types'

  export default {
    name: 'RightClickMenu',
    components: { AccessModal, RenameModal },

    props: {
      position: { type: Object, required: true },
      currentObj: { type: Object, required: true },
      acl: { type: Object, default: () => {} },
      replacedItems: { type: Array, default: () => [] },
    },

    data() {
      return {
        renameModal: false,
        accessModal: false,
        defaultItems: [
          { title: 'Переименовать', callback: () => this.showRename(), level: 'canWrite' },
          { title: 'Доступы', callback: () => this.showAccess(), level: 'canFull' },
          {
            title: 'Удалить',
            callback: () => this.$store.dispatch('removeObj', this.currentObj),
            level: 'canFull',
          },
        ],
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
          let list = this.replacedItems.length > 0 ? this.replacedItems : this.defaultItems
          list = list.filter(item => {
            if (!this.acl || !item.level) return true
            return this.acl[item.level]
          })
          return list
        },
      },
    },

    methods: {
      showRename() {
        this.renameModal = true
      },

      showAccess() {
        this.accessModal = true
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
