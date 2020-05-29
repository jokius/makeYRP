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
      <counters-list :list="menu.items" />
    </div>

    <add-counter-modal v-model="obj" />
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import CountersList from './CountersList'

  import AddCounterModal from '../modals/AddCounterModal'

  export default {
    name: 'EouTabCounters',
    components: { AddCounterModal, CountersList },
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
          return this.menus.find(item => item.type === 'eou-clock')
        },
      },

      obj: {
        get() {
          return { open: this.modalOpen, counter: {} }
        },

        set({ open, counter }) {
          this.addItem(counter)
          this.modalOpen = open
        },
      },
    },

    methods: {
      addItem({ title }) {
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'add',
          data: { menu_id: this.menu.id,  params: { title, max: 5, current: 0 }, type: 'menu_item' },
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
