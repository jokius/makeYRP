<template>
  <div>
    <div class="black grid-title">
      <span class="title">таланты</span>
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
    name: 'TeamTalents',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      talents: {
        get() {
          return this.sheet.params.talents
        },
      },
    },

    methods: {
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

  .grid-title {
    margin-bottom: 10px;
    height: 40px;
  }

  .title {
    line-height: 40px;
    margin-left: 5px;
  }

  .button {
    margin-right: 10px;
    cursor: pointer;
  }

  .black {
    background-color: $black;
    color: $white;
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
