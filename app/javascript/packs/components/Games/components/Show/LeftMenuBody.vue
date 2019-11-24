<template>
  <v-navigation-drawer
    ref="drawer"
    class="menuBody"
    permanent
    :width="navigation.width"
  >
    <tab-sheets v-if="menuType === 'sheets'" />
    <tab-settings v-else-if="menuType === 'settings'" />
  </v-navigation-drawer>
</template>

<script>
  import { mapState } from 'vuex'

  import TabSheets from '../../components/Show/TabSheets'
  import TabSettings from '../../components/Show/TabSettings'

  export default {
    name: 'LeftMenuBody',
    components: { TabSheets, TabSettings },
    data() {
      return {
        navigation: {
          width: 356,
          borderSize: 3,
        },
      }
    },
    computed: {
      ...mapState({
        leftMenus: (state) => state.game.leftMenus,
        currentMenu: (state) => state.game.currentMenu,
      }),
      menuType() {
        return this.leftMenus[this.currentMenu].type
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
  @import 'app/javascript/packs/components/ui/css/colors';

  .menuBody {
    position: fixed;
    z-index: 100;
    top: 60px !important;
    height: 100vh;
    background-color: $white;
  }
</style>
