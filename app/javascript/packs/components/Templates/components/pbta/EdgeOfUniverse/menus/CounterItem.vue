<template>
  <div class="clock-item-grid">
    <div class="steps">
      <v-stepper>
        <div class="title-grid">
          <span class="counter-title">{{ title }}</span>
          <v-btn
            color="red darken-4"
            dark
            text
            @click="deleteClock"
          >
            <v-icon>mdi-delete</v-icon>
          </v-btn>
        </div>
        <v-stepper-header>
          <template v-for="step in max">
            <v-stepper-step
              :key="`${step}-step`"
              :complete="current >= step"
              class="step-button"
              :step="step"
              color="black"
              dark
              @click="current = step"
            />
            <v-divider
              v-if="step !== max"
              :key="step"
            />
          </template>
        </v-stepper-header>
      </v-stepper>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'CounterItem',

    props: {
      clock: { type: Object, required: true },
    },

    computed: {
      title: {
        get() {
          return this.clock.params.title
        },
      },

      current: {
        get() {
          return this.clock.params.current
        },

        set(value) {
          const current = this.current === value && value === 1 ? 0 : value
          this.$cable.perform({
            channel: 'MenusItemChannel',
            action: 'change',
            data: { ...this.clock.params, current },
          })
        },
      },

      max: {
        get() {
          return this.clock.params.max
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
    grid-template-columns: 1fr;
  }

  .title-grid {
    display: grid;
    grid-template-columns: 1fr max-content;
    justify-items: center;
    align-items: center;
  }

  .counter-title {
    font-size: 17px;
    font-weight: bold;
  }

  .step-button {
    cursor: pointer;
  }
</style>
