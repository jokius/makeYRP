<template>
  <div class="compartments">
    <details class="pointer" open>
      <summary class="black-title">{{ engineeringCompartment.name }}</summary>
      <div class="compartments-grid">
        <compartment
          v-for="(compartment, index) in engineeringCompartment.items"
          :key="`engineeringCompartment-${index}`"
          :sheet="sheet"
          :compartment="compartment"
          :index="index"
          path="engineeringCompartment.items"
        />
      </div>
    </details>
    <details class="pointer" open>
      <summary class="black-title">{{ runningCompartment.name }}</summary>
      <div class="compartments-grid">
        <compartment
          v-for="(compartment, index) in runningCompartment.items"
          :key="`runningCompartment-${index}`"
          :sheet="sheet"
          :compartment="compartment"
          :index="index"
          path="runningCompartment.items"
        />
      </div>
    </details>
    <details class="pointer" open>
      <summary class="black-title">{{ bridge.name }}</summary>
      <div class="compartments-grid">
        <compartment
          v-for="(compartment, index) in bridge.items"
          :key="`bridge-${index}`"
          :sheet="sheet"
          :compartment="compartment"
          :index="index"
          path="bridge.items"
        />
      </div>
    </details>
    <details class="pointer" open>
      <summary class="black-title">{{ gunCompartment.name }}</summary>
      <div class="compartments-grid">
        <compartment
          v-for="(compartment, index) in gunCompartment.items"
          :key="`gunCompartment-${index}`"
          :sheet="sheet"
          :compartment="compartment"
          :index="index"
          path="gunCompartment.items"
        />
      </div>
    </details>
    <details class="pointer" open>
      <summary class="black-title">{{ hull.name }}</summary>
      <div class="compartments-grid">
        <compartment
          v-for="(compartment, index) in hull.items"
          :key="`hull-${index}`"
          :sheet="sheet"
          :compartment="compartment"
          :index="index"
          path="hull.items"
        />
      </div>
    </details>
    <details class="pointer" open>
      <summary class="black-title">{{ hangar.name }}</summary>
      <div class="compartments-grid">
        <compartment
          v-for="(compartment, index) in hangar.items"
          :key="`hold-${index}`"
          :sheet="sheet"
          :compartment="compartment"
          :index="index"
          path="hangar.items"
        />
      </div>
    </details>
    <details class="pointer" open>
      <summary class="black-title">{{ hold.name }}</summary>
      <div class="compartments-grid">
        <compartment
          v-for="(compartment, index) in hold.items"
          :key="`hold-${index}`"
          :sheet="sheet"
          :compartment="compartment"
          :index="index"
          path="hold.items"
        />
      </div>
    </details>
    <details class="pointer" open>
      <summary class="black-title">{{ scienceCompartment.name }}</summary>
      <div class="compartments-grid">
        <compartment
          v-for="(compartment, index) in scienceCompartment.items"
          :key="`hold-${index}`"
          :sheet="sheet"
          :compartment="compartment"
          :index="index"
          path="scienceCompartment.items"
        />
      </div>
    </details>
    <details class="pointer" open>
      <summary class="black-title">{{ hydroponicCompartment.name }}</summary>
      <div class="compartments-grid">
        <compartment
          v-for="(compartment, index) in hydroponicCompartment.items"
          :key="`hold-${index}`"
          :sheet="sheet"
          :compartment="compartment"
          :index="index"
          path="hydroponicCompartment.items"
        />
      </div>
    </details>
    <details class="pointer" open>
      <summary class="black-title">{{ otherSystems.name }}</summary>
      <div class="compartments-grid">
        <compartment-editable
          v-for="(compartment, index) in otherSystems.items"
          :key="`hold-${index}`"
          :sheet="sheet"
          :compartment="compartment"
          :index="index"
          path="otherSystems.items"
        />
      </div>
    </details>
    <div class="actions">
      <v-btn
        class="button-add"
        raised
        color="black"
        dark
        @click="addCompartment"
      >
        Добавить модуль
      </v-btn>
    </div>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import Compartment from './Compartment'
  import CompartmentEditable from './CompartmentEditable'

  import { UPDATE_SHEET_PARAMS } from '../../../../../Games/stores/mutation-types'

  export default {
    name: 'ShipCompartments',
    components: { CompartmentEditable, Compartment },
    props: {
      id: { type: Number, required: true },
    },

    computed: {
      ...mapState({
        sheets: state => state.game.sheets,
      }),

      sheet: {
        get() {
          return this.sheets.find(sheet => sheet.id === this.id)
        },
      },

      engineeringCompartment: {
        get() {
          return this.sheet.params.compartments.engineeringCompartment
        },
      },

      runningCompartment: {
        get() {
          return this.sheet.params.compartments.runningCompartment
        },
      },

      bridge: {
        get() {
          return this.sheet.params.compartments.bridge
        },
      },

      gunCompartment: {
        get() {
          return this.sheet.params.compartments.gunCompartment
        },
      },

      hull: {
        get() {
          return this.sheet.params.compartments.hull
        },
      },

      hangar: {
        get() {
          return this.sheet.params.compartments.hangar
        },
      },

      hold: {
        get() {
          return this.sheet.params.compartments.hold
        },
      },

      scienceCompartment: {
        get() {
          return this.sheet.params.compartments.scienceCompartment
        },
      },

      hydroponicCompartment: {
        get() {
          return this.sheet.params.compartments.hydroponicCompartment
        },
      },

      otherSystems: {
        get() {
          return this.sheet.params.compartments.otherSystems
        },
      },
    },

    methods: {
      addCompartment() {
        const compartment = {
          name: 'Новый компонет',
          enable: false,
          damaged: false,
          description: '',
          tags: [],
        }

        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `compartments.otherSystems.items[${this.otherSystems.items.length}]`,
                             value: compartment,
                           })

        this.saveSheet()
      },

      selectSet(path, value) {
        this.$store.commit(UPDATE_SHEET_PARAMS, { id: this.sheet.id, path, value })
        this.saveSheet()
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

  .pointer {
    cursor: pointer;
  }

  .compartments {
    background-color: $grayC5;
  }

  .compartments-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    grid-column-gap: 15px;
  }

  .black-title {
    margin-top: 5px;
    margin-bottom: 5px;
    font-size: 20px;
    font-weight: bold;
    text-align: center;
  }

  .black {
    background-color: $black;
    color: $white;
    text-align: center;
  }

  .actions {
    display: grid;
    grid-template-columns: max-content;
    justify-content: center;
    margin-top: 15px;
    margin-bottom: 5px;
  }
</style>
