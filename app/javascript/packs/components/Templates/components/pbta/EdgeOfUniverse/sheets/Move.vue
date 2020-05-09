<template>
  <div class="move-block">
    <div :class="typeof move.enable === 'boolean' ? 'title-move-checkbox' : 'title-move'">
      <div
        v-if="typeof move.enable === 'boolean'"
        :class="[{enable: enable }, 'box']"
        @click="changeMove(!enable)"
      />
      <div v-if="typeof move.full === 'string'" class="title-cell button">
        <span class="dice dice6 white-dice" @click="modalOpen = true">25</span>
        <span class="move-name" @click="modalOpen = true">
          {{ move.name }}
        </span>
      </div>
      <span v-else class="move-name">{{ move.name }}</span>
      <v-spacer />
      <v-btn
        v-if="move.remove"
        color="red darken-4"
        icon
        small
        dark
        class="delete-button"
        @click="removeMove"
      >
        <v-icon>mdi-delete</v-icon>
      </v-btn>
    </div>

    <details>
      <summary class="pointer">
        Подробнее
      </summary>
      <div v-if="typeof move.full === 'string'" class="actions">
        <v-btn
          class="button-add"
          raised
          color="black"
          small
          dark
          @click="autoFull"
        >
          Авто полный успех
        </v-btn>
        <v-btn
          class="button-add"
          raised
          color="black"
          small
          dark
          @click="autoPart"
        >
          Авто частичный успех
        </v-btn>
        <div class="select-grid">
          <span class="select-title">Способ</span>
          <v-select
            v-if="typeof move.type === 'object'"
            v-model="type"
            :items="move.type"
            class="type-select"
            color="black"
            flat
            hide-details
          />
        </div>
      </div>

      <span class="move-description" v-html="move.description" />
      <v-text-field
        v-if="texField"
        v-model="texField"
        color="indigo"
        class="input name"
        flat
        hide-details
        @change="saveSheet"
      />
      <v-textarea
        v-if="textarea"
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
          hide-details
          @change="value => otherSelect(selectIndex, value)"
        />
      </div>
    </details>

    <roll-modifier-modal v-model="obj" />
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import { UPDATE_SHEET_PARAMS } from '../../../../../Games/stores/mutation-types'
  import RollModifierModal from '../modals/RollModifierModal'

  export default {
    name: 'Move',
    components: { RollModifierModal },
    props: {
      move: { type: Object, required: true },
      index: { type: Number, required: true },
      path: { type: String, required: true },
      sheet: { type: Object, required: true },
    },

    data() {
      return {
        privateType: {},
        modalOpen: false,
        enable: false,
      }
    },

    computed: {
      ...mapState({
        sheets: state => state.game.sheets,
        tables: state => state.game.info.template.tables,
      }),

      type: {
        get() {
          return this.privateType
        },

        set(value) {
          this.privateType = value
        },
      },

      texField: {
        get() {
          return this.move.texField
        },

        set(value) {
          this.input('texField', value)
        },
      },

      textarea: {
        get() {
          return this.move.textarea
        },

        set(value) {
          this.input('textarea', value)
        },
      },

      selects: {
        get() {
          return this.move.selects
        },
      },

      results: {
        get() {
          return {
            full: this.move.full,
            part: this.move.part,
            fail: this.move.fail,
          }
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
    },

    created() {
      if (typeof this.move.type === 'object') {
        this.privateType = this.move.type[0].value
      } else {
        this.privateType = this.move.type
      }

      this.enable = this.move.enable
    },

    methods: {
      otherSelect(index, value) {
        this.input(`selects[${index}].value`, value)
        this.saveSheet()
      },

      changeMove(value) {
        this.enable = value
        this.input('enable', value)
        this.saveSheet()
      },

      removeMove() {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: this.path,
                             value: this.index,
                             remove: true,
                           })
        this.saveSheet()
      },

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

      autoFull() {
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'add',
          data: {
            type: 'message',
            body: {
              as: this.sheet.id,
              name: this.move.name,
              autoFull: true,
              results: this.results,
              detailsAlways: this.move.detailsAlways || false,
              details: this.move.details,
            },
          },
        })
      },

      autoPart() {
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'add',
          data: {
            type: 'message',
            body: {
              as: this.sheet.id,
              name: this.move.name,
              autoPart: true,
              results: this.results,
              detailsAlways: this.move.detailsAlways || false,
              details: this.move.details,
            },
          },
        })
      },

      roll(modifier) {
        const state = { name: this.tables.stats[this.type], value: this.sheet.params.stats[this.type] }
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'add',
          data: {
            type: 'message',
            body: {
              as: this.sheet.id,
              name: this.move.name,
              dices: { d6: 2 },
              state,
              modifier,
              results: this.results,
              detailsAlways: this.move.detailsAlways || false,
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

  .move-block {
    margin-bottom: 5px;
  }

  .title-move-checkbox {
    display: grid;
    grid-template-columns: 30px max-content 1fr max-content;
    background-color: $black;
    color: $white;
    height: 35px;
    line-height: 35px;
    margin-left: -5px;
  }

  .title-move {
    display: grid;
    grid-template-columns: max-content 1fr max-content;
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

  .move-name {
    margin-left: 5px;
    font-weight: 600;
  }

  .type-select {
    padding: 0;
    margin: 0;
    background-color: $white;
  }

  .select-grid {
    display: grid;
    grid-template-columns: max-content 135px;
    grid-column-gap: 10px;
    height: 35px;
  }

  .selects {
    display: grid;
    grid-template-columns: 1fr;
  }

  .select-title {
    line-height: 35px;
  }

  .delete-button {
    margin-top: 4px;
  }

  .actions {
    display: grid;
    grid-template-columns: max-content;
    grid-row-gap: 10px;
    margin-top: 15px;
    margin-bottom: 5px;
  }

  .white-dice {
    background-color: $white;
    color: $black;
  }
</style>
