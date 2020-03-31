<template>
  <div class="move-grid">
    <div :class="typeof move.enable === 'boolean' ? 'title-move-checkbox' : 'title-move'">
      <div
        v-if="typeof move.enable === 'boolean'"
        :class="[{enable: move.enable }, 'box']"
        @click="changeMove(!move.enable)"
      />

      <span
        v-if="typeof move.full === 'string' || typeof move.who === 'object'"
        class="move-name button"
        @click="modalOpen = true"
      >
        {{ move.name }}
      </span>
      <span v-else class="move-name">{{ move.name }}</span>
      <v-select
        v-if="typeof move.type === 'object'"
        v-model="type"
        :items="move.type"
        class="type-select"
        color="black"
        dark
        flat
      />
      <v-select
        v-if="typeof move.who === 'object'"
        v-model="who"
        :items="move.who"
        class="who-select"
        color="black"
        dark
        flat
      />
    </div>

    <span class="move-description" v-html="move.description" />
    <roll-modifier-modal v-model="obj" />
  </div>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../../Games/stores/mutation-types'
  import RollModifierModal from '../modals/RollModifierModal'

  export default {
    name: 'Move',
    components: { RollModifierModal },
    props: {
      move: { type: Object, required: true },
      path: { type: String, required: true },
      sheet: { type: Object, required: true },
    },

    data() {
      return {
        privateType: null,
        privateWho: null,
        modalOpen: false,
      }
    },

    computed: {
      type: {
        get() {
          return this.privateType || this.move.type
        },

        set(value) {
          this.privateType = value
        },
      },

      who: {
        get() {
          return this.privateWho
        },

        set(value) {
          this.privateWho = value
        },
      },

      obj: {
        get() {
          return { open: this.modalOpen, modifier: 0 }
        },

        set({ open, modifier, isClose }) {
          if (!isClose) this.roll(parseInt(modifier))
          this.modalOpen = open
        },
      },

      characteristics: {
        get() {
          return this.sheet.params.characteristics
        },
      },
    },

    created() {
      console.log('this.move', this.move)
      if (typeof this.move.type === 'object') {
        this.privateType = this.move.type[0]
      }

      if (typeof this.move.who === 'object') {
        this.privateWho = this.move.who[0]
      }
    },

    methods: {
      changeMove(value) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: this.path,
                             value,
                           })
        this.saveSheet()
      },

      saveSheet() {
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'change',
          data: { ...this.sheet, type: 'sheet' },
        })
      },

      roll(modifier) {
        const characteristic = this.characteristics.find(item => item.type === this.type)
        let results = {}
        if (this.who) {
          results = this.move[this.who]
        } else {
          results.full = this.move.full
          results.part = this.move.part
          results.fail = this.move.fail
        }


        this.$cable.perform({
          channel: 'GameChannel',
          action: 'add',
          data: {
            type: 'message',
            body: {
              as: this.sheet.id,
              name: this.move.name,
              dices: { d6: 2 },
              characteristic,
              modifier,
              results,
              details: this.move.details,
            },
          },
        })
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .move-grid {
    display: grid;
    margin-bottom: 5px;
  }

  .title-move-checkbox {
    display: grid;
    grid-template-columns: 30px max-content repeat(2, 135px);
    background-color: $black;
    color: $white;
    height: 35px;
    line-height: 35px;
  }

  .title-move {
    display: grid;
    grid-template-columns: max-content repeat(2, 135px);
    background-color: $black;
    color: $white;
    height: 35px;
    line-height: 35px;
  }

  .button {
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

  .move-name {
    font-size: 18px;
    font-weight: 600;
  }

  .type-select {
    height: 35px;
    padding: 0;
    margin: 0 0 0 10px;
  }

  .who-select {
    height: 35px;
    padding: 0;
    margin: 0 0 0 10px;
  }
</style>
