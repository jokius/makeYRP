<template>
  <v-bottom-navigation v-model="bottomMenu" :color="color">
    <v-btn
      v-for="(menu, index) in leftMenus"
      :key="index"
      @click="changeCurrentMenu(index)"
    >
      <span>{{ menu.label }}</span>
      <v-icon class="menuButton">{{ menu.icon }}</v-icon>
    </v-btn>
  </v-bottom-navigation>
</template>

<script>
  import { mapState } from 'vuex'

  import { UPDATE_CURRENT_MENU, UPDATE_LEFT_MENU } from '../../stores/mutation-types'

  export default {
    name: 'ActionButtons',
    computed: {
      ...mapState({
        leftMenus: (state) => state.game.leftMenus,
        currentMenu: (state) => state.game.currentMenu,
        game: (state) => state.game.info,
      }),

      bottomMenu: {
        get() {
          return this.currentMenu
        },
        set() {},
      },

      color() {
        return this.currentMenu >= 0 ? 'indigo' : 'rgba(0,0,0,.54)'
      },
    },
    created() {
      const list = this.game.menus.map((menu) => ({ label: menu.label, ...menu.params }))
      this.$store.commit(
        UPDATE_LEFT_MENU,
        list.concat([
          { label: 'Персонажи', icon: 'mdi-account', type: 'sheets' },
          { label: 'Карты', icon: 'mdi-map', type: 'maps' },
          { label: 'Настройки страници', icon: 'mdi-settings', type: 'settings' },
        ])
      )
    },

    methods: {
      changeCurrentMenu(value) {
        this.$store.commit(UPDATE_CURRENT_MENU, value)
      },
    },
  }
</script>

<style scoped lang="scss">
  .menuButton {
    margin-top: 8px;
  }
</style>
