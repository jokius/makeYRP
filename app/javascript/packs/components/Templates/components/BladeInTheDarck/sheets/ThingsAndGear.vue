<template>
  <div>
    <div class="grid-things-and-gear">
      <div class="title-grid black">
        <span class="title">Нагрузка</span>
        <div class="weight">
          <v-select
            v-model="weight"
            :items="items"
            class="role"
            color="indigo"
            dark
            dense
            hide-details
          />
        </div>
      </div>
      <div
        v-for="(item, index) in gear"
        :key="`gear-${index}`"
        class="gear"
      >
        <div
          v-for="weightBlock in item.weight"
          :key="`weightBlock-${index}_${weightBlock}`"
          class="box-line"
          @click="changeGear(index)"
        >
          <div :class="[{enable: item.enable }, 'box']" />
          <div v-if="needSeparate(weightBlock, item.weight)" class="separator" />
        </div>
        <span class="name" v-html="item.name" />
      </div>
    </div>
  </div>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'

  export default {
    name: 'ThingsAndGear',
    props: {
      sheet: { type: Object, required: true },
    },

    data() {
      return {
        // TODO: Move to template
        items: [
          { value: 0, text: '0: нет' },
          { value: 1, text: '1–3: лёгкая' },
          { value: 4, text: '4–5: нормальная' },
          { value: 6, text: '6: тяжёлая' },
          { value: 7, text: '7–9: перегруз' },
        ],
      }
    },

    computed: {
      weight: {
        get() {
          return this.sheet.params.weight
        },

        set(value) {
          this.input('weight', value)
          this.saveSheet()
        },
      },

      gear: {
        get() {
          return this.sheet.params.gear
        },
      },
    },

    methods: {
      needSeparate(weightBlock, itemWeight) {
        return (weightBlock === 1 && itemWeight > 1) || weightBlock < itemWeight
      },


      changeGear(index) {
        const value = !this.gear[index].enable
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `gear[${index}].enable`,
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

  .black {
    background-color: $black;
    color: $white;
  }

  .title-grid {
    display: grid;
    grid-template-columns: 1fr 225px;
    height: 40px;
    padding-right: 10px;
  }

  .title {
    line-height: 40px;
    margin-left: 5px;
  }

  .gear {
    display: inline-flex;
    position: relative;
    width: 100%;
    margin-top: 5px;
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

  .separator {
    border-top: 4px solid #000;
    height: 1px;
    width: 5px;
    position: relative;
    top: 11px;
  }

  .name {
    margin-left: 5px;
  }
</style>
