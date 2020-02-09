<template>
  <div>
    <div v-for="(minion, index) in minions" :key="minion.id">
      <div class="black grid-title">
        <span class="title">подручный</span>
        <div class="type">
          <v-select
            v-model="minion.type"
            :items="types"
            color="indigo"
            dark
            dense
            hide-details
          />
        </div>
      </div>
      <div class="grid-states">
        <div class="state box-line jfs">
          <div
            :class="[{enable: minion.weakened }, 'box']"
            @click="changeState(index, 'weakened', !minion.weakened)"
          />
          <span class="name-ml">ослаблен</span>
        </div>
        <div class="state box-line jfe">
          <span class="name-mr">бесполезен</span>
          <div
            :class="[{enable: minion.useless }, 'box']"
            @click="changeState(index, 'useless', !minion.useless)"
          />
        </div>
        <div class="state box-line jfs">
          <div
            :class="[{enable: minion.ineffective }, 'box']"
            @click="changeState(index, 'ineffective', !minion.ineffective)"
          />
          <span class="name-ml">неэффективен</span>
        </div>
        <div class="state box-line jfe">
          <span class="name-mr">защита</span>
          <div
            :class="[{enable: minion.protection }, 'box']"
            @click="changeState(index, 'protection', !minion.protection)"
          />
        </div>
      </div>
      <div class="box-line">
        <v-text-field
          class="input"
          color="indigo"
          flat
          :value="minion.name"
          @input="value => inputName(index, value)"
          @change="saveSheet"
        />

        <v-btn
          class="remove"
          tile
          x-small
          @click="removeMinion(index)"
        >
          Удалить
        </v-btn>
      </div>
    </div>
    <div class="actions">
      <v-btn
        class="button-add"
        rounded
        @click="addMinion"
      >
        Добавить подручного
      </v-btn>
    </div>
  </div>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'
  import { BiD } from '../../../../../lib/BiD'

  export default {
    name: 'TeamMinions',
    props: {
      sheet: { type: Object, required: true },
    },

    data() {
      return {
        types: [
          { text: 'шайка', value: 'gang' },
          { text: 'спец', value: 'specialist' },
        ],
      }
    },

    computed: {
      minions: {
        get() {
          return this.sheet.params.minions
        },
      },
    },

    methods: {
      inputName(index, value) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `minions.${index}.name`,
                             value,
                           })
      },

      changeState(index, state, value) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `minions.${index}.${state}`,
                             value,
                           })

        this.saveSheet()
      },

      addMinion() {
        const list = this.minions.slice()
        list.push(BiD.getEmptyMinion)
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'minions',
                             value: list,
                           })

        this.saveSheet()
      },

      removeMinion(value) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'minions',
                             value,
                             remove: true,
                           })

        this.saveSheet()
      },

      saveSheet() {
        this.$store.dispatch('saveSheet', this.sheet)
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .black {
    background-color: $black;
    color: $white;
  }

  .grid-title {
    display: grid;
    grid-template-columns: 1fr 145px;
    height: 40px;
    /*padding-right: 10px;*/
  }

  .title {
    line-height: 40px;
    margin-left: 5px;
  }

  .grid-states {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    /*padding-right: 10px;*/
  }

  .box-line {
    display: inline-flex;
  }

  .box {
    cursor: pointer;
    width: 15px;
    height: 15px;
    margin-top: 5px;
    border: 2px solid $black;
    background-color: $white;
  }

  .enable {
    background-color: $black;
  }

  .name-ml {
    margin-left: 5px;
  }

  .name-mr {
    margin-right: 5px;
  }

  .jfs {
    justify-self: start;
  }

  .jfe {
    justify-self: end;
  }

  .input {
    padding: 0;
    margin: 0 0 3px;
  }

  .remove {
    margin-top: 12px;
    margin-left: 40px;
  }

  .actions {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 100%;
  }
</style>
