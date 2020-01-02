<template>
  <div class="base">
    <div class="damage">
      <div class="black">
        <span class="title">повреждения</span>
      </div>
      <div class="damage-table">
        <div class="level">
          <span class="level-text">3</span>
          <input v-model="level3" class="level-input" @change="saveSheet" />
          <span class="level-info">беспомощность</span>
        </div>
        <div class="level">
          <span class="level-text">2</span>
          <input v-model="level2_1" class="level-input half border-r" @change="saveSheet" />
          <input v-model="level2_2" class="level-input half" @change="saveSheet" />
          <span class="level-info">-1 кубик</span>
        </div>
        <div class="level">
          <span class="level-text">1</span>
          <input v-model="level1_1" class="level-input half border-r" @change="saveSheet" />
          <input v-model="level1_2" class="level-input half" @change="saveSheet" />
          <span class="level-info">снижена эффективность</span>
        </div>
      </div>
    </div>

    <div class="heal-protection">
      <div class="black">
        <span class="title">лечение</span>
      </div>
      <clock
        v-model="treatmentCounter"
        title="счётчик"
        class="clock-block"
        :self-title-style="{ marginTop: '33px' }"
      />

      <div class="protection">
        <div class="black">
          <span class="title">защита</span>
        </div>
        <v-checkbox
          v-for="(item, index) in sheet.params.protection"
          :key="`protection_${item.key}`"
          :value="item.equip"
          :label="item.name"
          color="black"
          class="checkbox"
          dense
          @change="(value) => changeProtection(value, index)"
        />
      </div>
    </div>
  </div>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'
  import Clock from '../ui/Clock'

  export default {
    name: 'DamageAndHeal',
    components: { Clock },
    props: {
      sheet: { type: Object, required: true },
    },

    data() {
      return {
        modalOpen: false,
      }
    },

    computed: {
      level1_1: {
        get() {
          return this.sheet.params.damage[0]
        },

        set(value) {
          this.$store.commit(UPDATE_SHEET_PARAMS,
                             {
                               id: this.sheet.id,
                               path: `damage.0`,
                               value,
                             })
        },
      },

      level1_2: {
        get() {
          return this.sheet.params.damage[1]
        },

        set(value) {
          this.$store.commit(UPDATE_SHEET_PARAMS,
                             {
                               id: this.sheet.id,
                               path: `damage.1`,
                               value,
                             })
        },
      },

      level2_1: {
        get() {
          return this.sheet.params.damage[2]
        },

        set(value) {
          this.$store.commit(UPDATE_SHEET_PARAMS,
                             {
                               id: this.sheet.id,
                               path: `damage.2`,
                               value,
                             })
        },
      },

      level2_2: {
        get() {
          return this.sheet.params.damage[3]
        },

        set(value) {
          this.$store.commit(UPDATE_SHEET_PARAMS,
                             {
                               id: this.sheet.id,
                               path: `damage.3`,
                               value,
                             })
        },
      },

      level3: {
        get() {
          return this.sheet.params.damage[4]
        },

        set(value) {
          this.$store.commit(UPDATE_SHEET_PARAMS,
                             {
                               id: this.sheet.id,
                               path: `damage.4`,
                               value,
                             })
        },
      },

      treatmentCounter: {
        get() {
          return this.sheet.params.treatmentCounter
        },

        set(value) {
          this.$store.commit(UPDATE_SHEET_PARAMS,
                             {
                               id: this.sheet.id,
                               path: `treatmentCounter.current`,
                               value,
                             })

          this.saveSheet()
        },
      },
    },

    created() {
      if (this.sheet.params.damage.length === 0) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'damage',
                             value: ['', '', '', ''],
                           })
      }
    },

    methods: {
      changeProtection(value, index) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `protection.${index}.equip`,
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

  $border: 1px solid $black;

  .base {
    display: inline-flex;
  }

  .title {
    width: max-content;
    padding: 3px;
  }

  .black {
    background-color: $black;
    color: $white;
  }

  .damage {
    width: 715px;
  }

  .level {
    display: inline-flex;
    width: 100%;
    height: 50px;
    text-align: center;
    vertical-align: middle;
    line-height: 50px;
  }

  .level-text {
    width: 20px;
  }

  .level-input {
    background-color: $white;
    width: 100%;
    border-bottom: $border;
  }

  .half {
    width: 50%;
  }

  .border-r {
    border-right: $border;
  }

  .level-info {
    width: 330px;
    margin-left: 2px;
  }

  .heal-protection {
    margin-left: 5px;
    width: 170px;
  }

  .clock-block {
    position: relative;
    bottom: 32px;
    left: 48px;
  }

  .checkbox {
    height: 30px;
    margin: 0;
  }

  .protection {
    width: 205px;
    margin-top: -30px;
  }
</style>
