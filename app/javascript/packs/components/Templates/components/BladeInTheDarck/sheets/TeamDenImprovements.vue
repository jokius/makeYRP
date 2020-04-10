<template>
  <div>
    <div v-for="(denImprovement, index) in denImprovements" :key="denImprovement.key">
      <div class="title">
        {{ denImprovement.name }}
      </div>
      <div class="improvements">
        <div
          v-for="(improvement, indexImprovement) in denImprovement.improvements"
          :key="improvement.key"
          class="improvement"
        >
          <div
            v-for="number in improvement.max"
            :key="`number-${index}_${number}`"
            class="box-line"
            @click="changeCurrent(index, indexImprovement)"
          >
            <div :class="[{enable: improvement.current >= number }, 'box']" />
            <div v-if="needSeparate(number, improvement.max)" class="separator" />
          </div>
          <span class="name">{{ improvement.name }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'

  export default {
    name: 'TeamDenImprovements',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      denImprovements: {
        get() {
          return this.sheet.params.denImprovements
        },
      },
    },

    methods: {
      needSeparate(number, max) {
        return (number === 1 && max > 1) || number < max
      },

      changeCurrent(index, indexImprovement) {
        const improvement = this.denImprovements[index].improvements[indexImprovement]
        const value = improvement.current < improvement.max ? improvement.current + 1 : 0
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `denImprovements[${index}].improvements[${indexImprovement}].current`,
                             value,
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

  .title {
    text-transform: uppercase;
    font-size: 18px;
    font-weight: bold;
    margin-top: 10px;
  }

  .improvements {
    display: grid;
    grid-template-columns: repeat(2, max-content);
    grid-column-gap: 5px;
    justify-content: space-between;
    /*padding-right: 10px;*/
  }

  .improvement {
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
