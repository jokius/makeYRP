<template>
  <div>
    <div
      v-for="(item, index) in improvements"
      :key="`improvements-${index}`"
      class="improvements"
    >
      <div
        v-for="number in item.max"
        :key="`number-${index}_${number}`"
        class="box-line"
        @click="changeCurrent(index)"
      >
        <div :class="[{enable: item.current >= number }, 'box']" />
        <div v-if="needSeparate(number, item.max)" class="separator" />
      </div>
      <span class="name" v-html="item.name" />
    </div>
  </div>
</template>

<script>
  export default {
    name: 'TeamImprovements',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      improvements: {
        get() {
          return this.sheet.params.teamImprovements
        },
      },
    },

    methods: {
      needSeparate(number, max) {
        return (number === 1 && max > 1) || number < max
      },

      changeCurrent(index) {
        const improvement = this.improvements[index]
        const value = improvement.current < improvement.max ? improvement.current + 1 : 0
        this.$store.commit('game/updateSheetParams',
                           {
                             id: this.sheet.id,
                             path: `teamImprovements[${index}].current`,
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
  @import '~assets/css/colors';

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

  .improvements {
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
