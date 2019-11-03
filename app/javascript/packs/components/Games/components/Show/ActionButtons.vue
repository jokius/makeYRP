<template>
  <div>
    <v-bottom-navigation v-model="bottomMenu" color="indigo">
      <div v-for="(menu, index) in leftMenus" :key="index">
        <v-btn :value="index">
          <span>{{ menu.label }}</span>
          <v-icon class="menuButton">{{ menu.icon }}</v-icon>
        </v-btn>
      </div>
    </v-bottom-navigation>
  </div>
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
        set(value) {
          this.$store.commit(UPDATE_CURRENT_MENU, value)
        },
      },
    },
    created() {
      const list = this.game.menus.map((menu) => ({ label: menu.label, ...menu.params }))
      this.$store.commit(
        UPDATE_LEFT_MENU,
        list.concat([
          { label: 'Персонажи', icon: 'mdi-account', type: 'tab-characters' },
          { label: 'Карты', icon: 'mdi-map', type: 'tab-maps' },
          { label: 'Настройки страници', icon: 'mdi-settings', type: 'tab-config' },
        ])
      )
    },
  }
</script>

<style scoped lang="scss">
  .menuButton {
    margin-top: 8px;
  }
</style>
