<template>
  <div class="equipment-body">
    <div class="equipments-grid">
      <equipment
        v-for="(item, index) in equipment"
        :key="`equipment-${index}`"
        :sheet="sheet"
        :item="item"
        :index="index"
        path="equipment"
      />
    </div>
    <div class="actions">
      <v-spacer />
      <v-btn
        class="button-add"
        raised
        color="black"
        dark
        @click="startingEquipmentOpen = true"
      >
        Выбрать стартовое снарежение
      </v-btn>
      <v-spacer />
      <v-btn
        class="button-add"
        raised
        color="black"
        dark
        @click="newItem"
      >
        Добавить снаряжение
      </v-btn>
      <v-spacer />
    </div>

    <add-starting-equipment-modal v-if="startingEquipmentOpen" v-model="startingObj" :role="params.role.key" />
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import Equipment from './Equipment'

  import { UPDATE_SHEET_PARAMS } from '../../../../../Games/stores/mutation-types'
  import AddStartingEquipmentModal from '../modals/AddStartingEquipmentModal'
  import { Pbta } from '../../../../../../lib/Pbta'

  export default {
    name: 'CharacterEquipmentBody',
    components: { AddStartingEquipmentModal, Equipment },
    props: {
      id: { type: Number, required: true },
    },

    data() {
      return {
        panels: [],
        startingEquipmentOpen: false,
      }
    },

    computed: {
      ...mapState({
        sheets: state => state.game.sheets,
        tables: state => state.game.info.template.tables,
      }),

      sheet: {
        get() {
          return this.sheets.find(sheet => sheet.id === this.id)
        },
      },

      params: {
        get() {
          return this.sheet.params
        },
      },

      equipment: {
        get() {
          return this.params.equipment
        },
      },

      startingObj: {
        get() {
          return { open: this.startingEquipmentOpen, items: [] }
        },

        set({ open, items }) {
          this.setEquipment(items)
          this.startingEquipmentOpen = open
        },
      },
    },

    methods: {
      setEquipment(items) {
        if (items.length === 0) return

        items.forEach(item => {
          if (!item.name) return

          this.$store.commit(UPDATE_SHEET_PARAMS,
                             {
                               id: this.sheet.id,
                               path: `equipment[${this.equipment.length}]`,
                               value: item,
                             })
        })

        this.saveSheet()
      },

      newItem() {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `equipment[${this.equipment.length}]`,
                             value: Pbta.newItem(),
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
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .equipment-body {
    background-color: $grayC5;
  }

  .equipments-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    grid-column-gap: 15px;
  }

  .actions {
    display: grid;
    grid-template-columns: 1fr max-content 10px max-content 1fr;
    margin-top: 15px;
    margin-bottom: 5px;
  }
</style>
