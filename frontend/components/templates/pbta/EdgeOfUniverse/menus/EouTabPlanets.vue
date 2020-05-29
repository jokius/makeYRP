<template>
  <div>
    <div class="grid">
      <v-btn
        v-if="currentUser.id === master.id"
        class="selectButton"
        color="indigo"
        tile
        dark
        @click="showModal"
      >
        Новая планета
      </v-btn>
      <planets-list :list="menu.items" />
    </div>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import PlanetsList from './PlanetsList'
  import { ItemMenuModel } from '../../../../../models/ItemMenuModel'

  export default {
    name: 'EouTabPlanets',
    components: { PlanetsList },
    data() {
      return {
        modalOpen: false,
      }
    },

    computed: {
      ...mapState({
        menus: state => state.game.info.menus,
        currentUser: state => state.game.currentUser,
        master: state => state.game.info.master,
      }),

      menu: {
        get() {
          return this.menus.find(item => item.type === 'eou-clock')
        },
      },
    },

    methods: {
      showModal() {
        const key = Date.now()
        const planet = new ItemMenuModel()
        planet.menuId = this.menu.id
        this.$store.commit('game/addOpenModal', {
          name: 'planet',
          key,
          isNew: true,
          isEdit: true,
          planet,
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
