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
          this.$store.commit('game/updateMenuItemParams', {
            id: this.clock.id,
            menuId: this.clock.menuId,
            path: 'current',
            value: this.current === value && value === 1 ? 0 : value,
          })

          this.$cable.perform({
            channel: 'GameChannel',
            action: 'change',
            data: { ...this.clock, type: 'menu_item' },
          })
        },
      },

      max: {
        get() {
          return this.clock.params.max
        },
      },
    },

    methods: {
      deleteClock() {
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'remove',
          data: { id: this.clock.id, type: 'menu_item' },
        })
      },
    },
  }
</script>

<style scoped lang="scss">
  @import '~assets/css/colors';

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
