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
      @click="deleteClock"
    >
      <v-icon>mdi-delete</v-icon>
    </v-btn>
  </div>
</template>

<script>
  import Clock from '../ui/Clock'

  export default {
    name: 'ClockItem',
    components: { Clock },

    props: {
      clock: { type: Object, required: true },
    },

    computed: {
      params: {
        get() {
          return this.clock.params
        },

        set(value) {
          this.$cable.perform({
            channel: 'MenusItemChannel',
            action: 'change',
            data: { ...this.clock.params, current: value },
          })
        },
      },
    },

    mounted() {
      this.$cable.subscribe({
        channel: 'MenusItemChannel',
        item_id: this.clock.id,
      })
    },

    methods: {
      deleteClock() {
        this.$cable.perform({ channel: 'MenusItemChannel', action: 'remove' })
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
