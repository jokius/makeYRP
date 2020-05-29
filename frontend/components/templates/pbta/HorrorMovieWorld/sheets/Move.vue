<template>
  <div class="move-grid">
    <div :class="typeof move.enable === 'boolean' ? 'title-move-checkbox' : 'title-move'">
      <div
        v-if="typeof move.enable === 'boolean'"
        :class="[{enable: move.enable }, 'box']"
        @click="changeMove(!move.enable)"
      />
      <div v-if="typeof move.full === 'string' || typeof move.who === 'object'" class="title-cell button">
        <span class="dice dice6">25</span>
        <span class="move-name" @click="modalOpen = true">
          {{ move.name }}
        </span>
      </div>
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
      <v-spacer v-else-if="typeof move.who !== 'object'" />
      <v-select
        v-if="typeof move.who === 'object'"
        v-model="who"
        :items="move.who"
        class="who-select"
        color="black"
        dark
        flat
      />
      <v-spacer v-else />
      <v-spacer />
      <span v-if="move.remove" class="move-remove" @click="removeMove">Удалить</span>
    </div>

    <span class="move-description" v-html="move.description" />
    <v-textarea
      v-if="move.textarea"
      v-model="textarea"
      auto-grow
      no-resize
      rows="2"
      color="indigo"
      background-color="white"
      class="notes"
      hide-details
      @change="saveSheet"
    />
    <div v-if="move.selects" class="selects">
      <v-select
        v-for="(select, selectIndex) in selects"
        :key="`other-select-${selectIndex}`"
        :items="select.items"
        class="other-select"
        color="black"
        :multiple="select.limit > 1"
        flat
        :value="select.value"
        :label="select.label"
        @change="value => otherSelect(selectIndex, value)"
      />
    </div>
    <roll-modifier-modal v-model="obj" />
  </div>
</template>

<script>
  import RollModifierModal from '../modals/RollModifierModal'

  export default {
    name: 'Move',
    components: { RollModifierModal },
    props: {
      move: { type: Object, required: true },
      index: { type: Number, required: true },
      sheet: { type: Object, required: true },
    },

    data() {
      return {
        privateType: {},
        privateWho: null,
        modalOpen: false,
      }
    },

    computed: {
      type: {
        get() {
          return this.privateType
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

      textarea: {
        get() {
          return this.move.textarea.value
        },

        set(value) {
          this.input('textarea.value', value)
        },
      },

      selects: {
        get() {
          return this.move.selects
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
      if (typeof this.move.type === 'object') {
        this.privateType = this.move.type[0].value
      } else {
        this.privateType = this.move.type
      }

      if (typeof this.move.who === 'object') {
        this.privateWho = this.move.who[0]
      }
    },

    methods: {
      otherSelect(index, value) {
        this.input(`selects[${index}].value`, value)
        this.saveSheet()
      },

      changeMove(value) {
        this.input('enable', value)
        this.saveSheet()
      },

      removeMove() {
        this.$store.commit('game/updateSheetParams',
                           {
                             id: this.sheet.id,
                             path: 'moves',
                             value: this.index,
                             remove: true,
                           })
        this.saveSheet()
      },

      input(target, value) {
        this.$store.commit('game/updateSheetParams',
                           {
                             id: this.sheet.id,
                             path: `moves[${this.index}].${target}`,
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
  @import '~assets/css/colors';

  .move-grid {
    display: grid;
    margin-bottom: 5px;
  }

  .title-move-checkbox {
    display: grid;
    grid-template-columns: 30px max-content repeat(2, 135px) 1fr max-content;
    background-color: $black;
    color: $white;
    height: 35px;
    line-height: 35px;
    margin-left: -5px;
  }

  .title-move {
    display: grid;
    grid-template-columns: max-content repeat(2, 135px) 1fr max-content;
    background-color: $black;
    color: $white;
    height: 35px;
    line-height: 35px;
    margin-left: -5px;
  }

  .dice {
    margin-left: 5px;
    margin-right: -5px;
    font-size: 16px;
  }

  .button {
    cursor: pointer;
    color: $white;
    &:hover,
    &:focus,
    &:active {
      color: $grayEE;
    }
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
    margin-left: 5px;
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

  .selects {
    display: grid;
    grid-auto-flow: column;
    grid-column-gap: 5px;
  }

  .move-remove {
    cursor: pointer;
    margin-right: 10px;
  }
</style>
