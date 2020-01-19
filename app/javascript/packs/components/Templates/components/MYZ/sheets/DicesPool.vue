<template>
  <div class="pool">
    <div
      v-for="dice in dices"
      :key="dice.key"
      class="dice-line"
    >
      <v-btn
        class="button-add"
        :style="dice.style || {}"
        outlined
        @click="incrementDice(dice.key)"
      >
        {{ dice.name }}
      </v-btn>
      <v-text-field
        :value="pool[dice.key]"
        required
        color="indigo"
        class="input-count"
        type="number"
        @input="value => changeDices(value, dice.key)"
      />
      <div class="dice-line-selected">
        <div
          v-for="item in pool[dice.key]"
          :key="`${dice.key}-${item}`"
          :style="dice.style"
          class="dice-selected"
          @click="decrementDice(dice.key)"
        />
      </div>
    </div>

    <div class="actions">
      <v-btn
        class="button-clear"
        rounded
        @click="initPool"
      >
        Очистить
      </v-btn>
      <v-btn
        class="button-roll"
        :disabled="rollDisabled"
        rounded
        color="orange"
        @click="roll"
      >
        Сделать бросок
      </v-btn>
    </div>
  </div>
</template>

<script>
  import Vue from 'vue'
  import { mapState } from 'vuex'

  export default {
    name: 'DicesPool',

    props: {
      id: { type: Number, required: true },
    },

    data() {
      return {
        pool: {},
      }
    },

    computed: {
      ...mapState({
        template: state => state.game.info.template,
      }),

      dices: {
        get() {
          const list = this.template.dices.slice()
          list.push({
            key: 'd6',
            dice: 'd6',
            name: 'd6',
          })
          return list
        },
      },

      rollDisabled: {
        get() {
          let disabled = true
          for (const key in this.pool) {
            if (this.pool[key] > 0) return disabled = false
          }

          return disabled
        },
      },
    },

    created() {
      this.initPool()
    },

    methods: {
      initPool() {
        this.dices.forEach(dice => Vue.set(this.pool, dice.key, 0))
      },

      incrementDice(key) {
        this.pool[key] += + 1
      },

      decrementDice(key) {
        this.pool[key] -= 1
      },

      changeDices(value, key) {
        const intVal = parseInt(value, 10)
        this.pool[key] = intVal >= 0 ? intVal : 0
      },

      roll() {
        this.$store.dispatch('sendMessage', { as: this.id, dices: this.pool })
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  $size: 36px;

  .button-add {
    color: $white;
    background-color: $black;
  }

  .dice-line {
    display: grid;
    grid-template-columns: 200px 60px auto;
    grid-template-rows: $size;
    grid-column-gap: 5px;
  }

  .dice-line-selected {
    display: flex;
  }

  .dice-selected {
    cursor: pointer;
    border: 1px solid $white;
    background-color: $black;
    border-radius: 8px;
    margin-right: 2px;
    width: $size;
    height: $size;
  }

  .input-count {
    margin: 0;
    padding: 0;
    &::before {
      content: 'x';
      padding-top: 3px;
      padding-right: 2px;
    }
  }

  .actions {
    margin-top: 20px;
  }

  .button-roll {
    margin-left: 5px;
  }
</style>
