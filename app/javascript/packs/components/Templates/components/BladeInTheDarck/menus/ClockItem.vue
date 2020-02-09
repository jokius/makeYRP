<template>
  <div class="clock-item-grid">
    <clock
      v-model="params"
      :title="clock.params.title"
      title-position="top"
      class="clock-block"
    />
    <v-btn
      color="red darken-4"
      fab
      x-small
      dark
      @click="deleteClock(clock.id)"
    >
      <v-icon>mdi-delete</v-icon>
    </v-btn>
  </div>
</template>

<script>
  import Clock from '../ui/Clock'
  import { DELETE_MENU_ITEM, UPDATE_MENU_ITEM } from '../../../../Games/stores/mutation-types'

  export default {
    name: 'ClockItem',
    components: { Clock },

    props: {
      clock: { type: Object, required: true },
    },

    channels: {
      MenusItemChannel: {
        received(obj) {
          if (obj.delete) {
            this.$cable.unsubscribe('MenusItemChannel')
            this.$store.commit(DELETE_MENU_ITEM, obj.delete)
          } else {
            this.$store.commit(UPDATE_MENU_ITEM, obj)
          }
        },
      },
    },

    computed: {
      params: {
        get() {
          return this.clock.params
        },

        set(value) {
          const id = this.clock.id
          const params = { ...this.clock.params, current: value }
          this.$store.dispatch('updateMenuItem', { id, params })
        },
      },
    },

    mounted() {
      this.$cable.subscribe({
        channel: 'MenusItemChannel',
        id: this.clock.id,
      })
    },

    methods: {
      deleteClock(id) {
        this.$store.dispatch('deleteMenuItem', id)
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .clock-item-grid {
    display: grid;
    grid-template-columns: 1fr max-content;
    justify-items: center;
    align-items: center;
    padding: 0 16px 5px 0;
    border-bottom: 1px solid $black;
  }
</style>
