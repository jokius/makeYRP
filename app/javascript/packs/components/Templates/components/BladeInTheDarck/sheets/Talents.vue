<template>
  <div>
    <div class="black grid-title">
      <span class="title">таланты</span>
      <div class="exp-list">
        <div
          v-for="number in talentsExp.max"
          :key="`talentsExp-${number}`"
          :class="`button bottom-block ${colorClass(number)}`"
          @click="changeExp(currentExp < number)"
        />
      </div>
    </div>
    <div class="talents-list">
      <div
        v-for="(talent, index) in talents"
        :key="`talent-${index}`"
        class="talent"
      >
        <v-checkbox
          :value="talent.enable"
          color="black"
          class="checkbox"
          hide-details
          dense
          @change="(value) => changeTalent(value, index)"
        />
        <v-textarea
          v-if="talent.editable"
          :value="talent.name"
          auto-grow
          no-resize
          flat
          rows="1"
          color="indigo"
          class="input"
          hide-details
          placeholder="Название и описание"
          @input="(value) => inputName(value, index)"
          @change="saveSheet"
        />
        <p v-else v-html="`<b>${talent.name}</b> ${talent.description}`" />
      </div>

      <div class="actions">
        <v-btn
          class="button-add"
          rounded
          @click="addTalent"
        >
          Добавить талант
        </v-btn>
      </div>
    </div>
  </div>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'
  import { BiD } from '../../../../../lib/BiD'

  export default {
    name: 'Talents',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      talents: {
        get() {
          return this.sheet.params.talents
        },
      },

      talentsExp: {
        get() {
          return this.sheet.params.talentsExp
        },
      },

      currentExp: {
        get() {
          return this.talentsExp.current
        },
      },
    },

    methods: {
      colorClass(number) {
        return this.currentExp >= number ? 'full-gray' : 'full-white'
      },

      changeExp(isIncrement) {
        const value = this.currentExp + (isIncrement ? 1 : -1)
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'talentsExp.current',
                             value,
                           })

        this.saveSheet()
      },

      inputName(value, index) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `talents.${index}.name`,
                             value,
                           })
      },

      changeTalent(value, index) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `talents.${index}.enable`,
                             value,
                           })

        this.saveSheet()
      },

      addTalent() {
        const list = this.talents.slice()
        list.push(BiD.getEmptyCharacterTalent)
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `talents`,
                             value: list,
                           })
      },

      saveSheet() {
        this.$store.dispatch('saveSheet', this.sheet)
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .grid-title {
    margin-bottom: 10px;
    height: 25px;
  }

  .title {
    width: max-content;
    position: relative;
    left: 3px;
    bottom: 25px;
  }

  .exp-list {
    position: relative;
    display: inline-flex;
    left: 59%;
  }

  .button {
    margin-right: 10px;
    cursor: pointer;
  }

  .bottom-block {
    width: 10px;
    height: 44px;
  }

  .black {
    background-color: $black;
    color: $white;
  }

  .full-gray {
    background:
      linear-gradient(-45deg, transparent 15px, $gray42 0);
  }

  .full-white {
    background:linear-gradient(-45deg, transparent 15px, $white 0);
  }

  .checkbox {
    position: relative;
    top: 5px;
    margin: 0;
    padding: 0;
    float: left;
    height: 20px;
  }

  .input {
    padding: 0;
    margin: 0 0 3px;
  }

  .actions {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 100%;
  }
</style>
