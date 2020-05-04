<template>
  <div class="compartment-block">
    <div :class="typeof enable === 'boolean' ? 'title-compartment-checkbox' : 'title-compartment'">
      <div
        v-if="typeof enable === 'boolean'"
        :class="[{ enable }, 'box']"
        @click="input('enable', !enable)"
      />
      <span class="compartment-name">{{ name }}</span>
      <v-spacer />
      <div
        :class="[{ enable: damaged }, 'box']"
        @click="input('damaged', !damaged)"
      />
      <span>Поврежден</span>
    </div>

    <details>
      <summary class="pointer">
        Подробнее
      </summary>
      <span v-if="offline" class="offline">Автономный</span>
      <span v-if="damage">Урон: {{ damage }}</span>
      <div v-if="counter" class="counter">
        <span class="counter-title">Счетчик</span>
        <div
          v-for="number in counter"
          :key="`counter-${number}`"
          class="box-line"
          @click="counter = number"
        >
          <div :class="[{ enable: counter >= number }, 'box']" />
        </div>
      </div>
      <span class="compartment-description" v-html="description" />
      <div v-if="tags" class="tags-grid">
        <span class="label tag-label">Теги</span>
        <v-chip-group>
          <v-chip
            v-for="(tag, tagIndex) in tags"
            :key="`tag-${tagIndex}`"
          >
            {{ tag }}
          </v-chip>
        </v-chip-group>
      </div>
    </details>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import { UPDATE_SHEET_PARAMS } from '../../../../../Games/stores/mutation-types'

  export default {
    name: 'Compartment',

    props: {
      compartment: { type: Object, required: true },
      index: { type: Number, required: true },
      path: { type: String, required: true },
      sheet: { type: Object, required: true },
    },

    computed: {
      ...mapState({
        sheets: state => state.game.sheets,
      }),

      enable: {
        get() {
          return this.compartment.enable
        },
      },

      damaged: {
        get() {
          return this.compartment.damaged
        },
      },

      name: {
        get() {
          return this.compartment.name
        },
      },

      offline: {
        get() {
          return this.compartment.offline
        },
      },

      damage: {
        get() {
          return this.compartment.damage
        },
      },

      counter: {
        get() {
          return this.compartment.counter
        },
      },

      description: {
        get() {
          return this.compartment.description
        },
      },

      tags: {
        get() {
          return this.compartment.tags
        },
      },
    },

    methods: {
      input(target, value) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `${this.path}[${this.index}].${target}`,
                             value: value,
                           })
      },

      saveSheet() {
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'change',
          data: { ...this.sheet, type: 'sheet' },
        })
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .compartment-block {
    margin-bottom: 5px;
  }

  .title-compartment-checkbox {
    display: grid;
    grid-template-columns: 30px max-content 1fr 30px max-content;
    grid-column-gap: 5px;
    background-color: $black;
    color: $white;
    height: 35px;
    line-height: 35px;
    margin-left: -5px;
    padding-right: 10px;
  }

  .title-compartment {
    display: grid;
    grid-template-columns: max-content 1fr 30px max-content;
    grid-column-gap: 5px;
    background-color: $black;
    color: $white;
    height: 35px;
    line-height: 35px;
    margin-left: -5px;
    padding-right: 10px;
  }

  .pointer {
    cursor: pointer;
  }

  .box {
    cursor: pointer;
    width: 20px;
    height: 20px;
    margin-left: 5px;
    margin-top: 7px;
    border: 2px solid $white;
  }

  .enable {
    background-color: $white;
    border: 2px solid $black;
  }

  .compartment-name {
    margin-left: 5px;
    font-weight: 600;
  }
</style>
