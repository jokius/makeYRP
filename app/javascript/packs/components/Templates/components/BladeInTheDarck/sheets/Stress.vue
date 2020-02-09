<template>
  <div>
    <div class="head-line" />
    <div class="inline-flex">
      <div class="inline-flex">
        <div>
          <div class="black">
            <span class="title">Стресс</span>
          </div>
        </div>
        <div
          v-for="number in stress.max"
          :key="`stress-${number}`"
          class="button"
          @click="changeStress(currentStress < number)"
        >
          <div v-if="currentStress >= number" class="full-black" />
          <div v-else>
            <div class="black-part" />
            <div class="empty-part" />
          </div>
        </div>
        <div class="injuries-title">
          <div class="black">
            <span class="title">Травмы</span>
          </div>
          <div class="injuries-marks">
            <div
              v-for="number in injuriesCount.max"
              :key="`injuries-${number}`"
              class="black-mark"
            />
          </div>
        </div>
      </div>
      <div class="inline-flex">
        <v-chip
          v-for="(item, index) in injuries"
          :key="`${index}-injuries`"
          close
          color="black"
          class="chip"
          @click:close="deleteInjury(index)"
        >
          {{ item.name }}
        </v-chip>

        <v-btn
          v-if="injuries.length < injuriesCount.max"
          class="button-plus"
          color="black"
          dark
          small
          fab
          @click="modalOpen = true"
        >
          <v-icon dark>mdi-plus</v-icon>
        </v-btn>
      </div>

      <add-injury-modal v-model="obj" :current-injuries="injuries" />
    </div>
  </div>
</template>

<script>
  import { isEmpty } from 'lodash'

  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'
  import AddInjuryModal from '../modals/AddInjuryModal'

  export default {
    name: 'Stress',
    components: { AddInjuryModal },
    props: {
      sheet: { type: Object, required: true },
    },

    data() {
      return {
        modalOpen: false,
      }
    },

    computed: {
      stress: {
        get() {
          return this.sheet.params.stress
        },
      },

      injuriesCount: {
        get() {
          return this.sheet.params.injuriesCount
        },
      },

      currentStress: {
        get() {
          return this.stress.current
        },
      },

      injuries: {
        get() {
          return this.sheet.params.injuries
        },
      },

      obj: {
        get() {
          return { open: this.modalOpen, injury: {} }
        },

        set({ open, injury }) {
          this.setInjury(injury)
          this.modalOpen = open
        },
      },
    },

    methods: {
      setInjury(injury) {
        if (isEmpty(injury)) return

        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `injuries.${this.injuries.length}`,
                             value: injury,
                           })

        this.saveSheet()
      },

      deleteInjury(index) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'injuries',
                             value: index,
                             remove: true,
                           })

        this.saveSheet()
      },

      changeStress(isIncrement) {
        const value = this.stress.current + (isIncrement ? 1 : -1)
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'stress.current',
                             value,
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

  .head-line {
    background-color: $black;
    height: 5px;
    width: 100%;
  }

  .inline-flex {
    display: inline-flex;
  }

  .title {
    width: max-content;
    padding: 3px;
  }

  .button {
    cursor: pointer;
  }

  .black {
    background-color: $black;
    color: $white;
  }

  .full-black {
    margin-right: 10px;
    width: 15px;
    height: 60px;
    background:
      linear-gradient(-45deg, transparent 15px, $black 0);
  }

  .black-part {
    margin-right: 10px;
    width: 15px;
    height: 35px;
    background:
      linear-gradient(-45deg, transparent 15px, $black 0),
      linear-gradient(45deg, transparent 0, $white 0);
  }

  .empty-part {
    margin-right: 10px;
    width: 15px;
    height: 25px;
    background:linear-gradient(-45deg, transparent 15px, $white 0);
  }

  .injuries-title {
    margin-left: -10px;
  }

  .injuries-marks {
    display: inline-flex;
    margin-left: 10px;
  }

  .black-mark {
    margin-right: 10px;
    width: 15px;
    height: 30px;
    background:
      linear-gradient(-45deg, transparent 15px, $black 0);
  }

  .button-plus {
    margin-top: 5px;
    margin-left: 2px;
  }

  .chip {
    margin-left: 2px;
    margin-top: 10px;
  }
</style>
