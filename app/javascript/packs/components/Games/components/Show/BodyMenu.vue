<template>
  <div class="menuGrid">
    <v-navigation-drawer
      ref="drawer"
      permanent
      right
      :width="navigation.width"
    >
      <template v-slot:prepend>
        <v-list-item>
          <v-list-item-icon>
            <v-icon>{{ currentItem.icon }}</v-icon>
          </v-list-item-icon>

          <v-list-item-content>
            <v-list-item-title>{{ currentItem.label }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </template>

      <v-divider />

      <keep-alive>
        <tab-chat v-if="currentItem.type === 'chat'" />
        <tab-sheets v-else-if="currentItem.type === 'sheets'" />
        <tab-settings v-else-if="currentItem.type === 'settings'" />
      </keep-alive>
    </v-navigation-drawer>
    <v-navigation-drawer
      dark
      color="indigo"
      permanent
      right
    >
      <v-list>
        <v-list-item
          v-for="(item, index) in items"
          :key="item.label"
          :disabled="currentIndex === index"
          @click="currentIndex = index"
        >
          <v-list-item-action>
            <v-tooltip left>
              <template v-slot:activator="{ on }">
                <v-icon v-on="on">{{ item.icon }}</v-icon>
              </template>
              <span>{{ item.label }}</span>
            </v-tooltip>
          </v-list-item-action>

          <v-list-item-content>
            <v-list-item-title>{{ item.label }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import TabChat from './TabChat'
  import TabSheets from './TabSheets'
  import TabSettings from './TabSettings'

  export default {
    name: 'BodyMenu',
    components: { TabSettings, TabSheets, TabChat },

    data() {
      return {
        currentIndex: 0,
        navigation: {
          width: 356,
          borderSize: 3,
        },
      }
    },

    computed: {
      ...mapState({
        menus: (state) => state.game.info.menus,
      }),

      items: {
        get() {
          const list = this.menus.map((menu) => ({ label: menu.label, ...menu.params }))
          return list.concat([
            { label: 'Чат', icon: 'mdi-chat', type: 'chat' },
            { label: 'Персонажи', icon: 'mdi-account', type: 'sheets' },
            { label: 'Карты', icon: 'mdi-map', type: 'maps' },
            { label: 'Настройки страници', icon: 'mdi-settings', type: 'settings' },
          ])
        },
      },

      currentItem: {
        get() {
          return this.items[this.currentIndex]
        },
      },
    },

    mounted() {
      this.setBorderWidth();
      this.setEvents();
    },

    methods: {
      setBorderWidth() {
        const drawer = this.$refs.drawer.$el.querySelector('.v-navigation-drawer__border')
        drawer.style.width = `${this.navigation.borderSize}px`
        drawer.style.cursor = 'ew-resize'
      },

      setEvents() {
        const minSize = this.navigation.borderSize
        const el = this.$refs.drawer.$el
        const drawerBorder = el.querySelector('.v-navigation-drawer__border')
        const vm = this
        const direction = el.classList.contains('v-navigation-drawer--right') ? 'right' : 'left'

        function resize(e) {
          document.body.style.cursor = 'ew-resize'
          const scroll = direction === 'right' ? document.body.scrollWidth - e.clientX : e.clientX
          el.style.width = `${scroll}px`
        }

        drawerBorder.addEventListener(
          'mousedown',
          function(e) {
            if (e.offsetX < minSize) {
              el.style.transition ='initial'
              document.addEventListener("mousemove", resize, false)
            }
          },
          false
        )

        document.addEventListener(
          'mouseup',
          function() {
            el.style.transition =''
            vm.navigation.width = el.style.width
            document.body.style.cursor = ""
            document.removeEventListener('mousemove', resize, false)
          },
          false
        );
      },
    },
  }
</script>

<style scoped lang="scss">
  .menuGrid {
    display: grid;
    grid-template-columns: auto 50px;
  }
</style>
