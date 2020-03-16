<template>
  <div>
    <div class="grid">
      <v-btn
        class="selectButton"
        color="indigo"
        tile
        dark
        @click="modalOpen = true"
      >
        Добавить счетчик
      </v-btn>
      <clock-list :list="menu.items" />
    </div>

    <add-clock-modal v-model="obj" />
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import ClockList from './ClockList'

  import AddClockModal from '../modals/AddClockModal'

  export default {
    name: 'BidTabClock',
    components: { ClockList, AddClockModal },
    data() {
      return {
        modalOpen: false,
      }
    },

    computed: {
      ...mapState({
        menus: state => state.game.info.menus,
      }),

      menu: {
        get() {
          return this.menus.find(item => item.type === 'bid-clock')
        },
      },

      obj: {
        get() {
          return { open: this.modalOpen, clock: {} }
        },

        set({ open, clock }) {
          this.addItem(clock)
          this.modalOpen = open
        },
      },
    },

    methods: {
      addItem({ title, counter }) {
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'add',
          data: { menu_id: this.menu.id,  params: { title, max: counter, current: 0 }, type: 'menu_item' },
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
