<template>
  <div>
    <div class="black grid-title">
      <span class="title">опыт команды</span>
      <div class="exp-list">
        <div
          v-for="number in exp.max"
          :key="`teamExp-${number}`"
          :class="`button bottom-block ${colorClass(number)}`"
          @click="changeExp(currentExp < number)"
        />
      </div>
    </div>
    <div class="exp-description">
      <p>{{ exp.description }}</p>
      <ul>
        <li v-for="(item, index) in exp.list" :key="`exp-info-${index}`">
          <i>{{ item }}</i>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'

  export default {
    name: 'TeamExp',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      exp: {
        get() {
          return this.sheet.params.exp
        },
      },

      currentExp: {
        get() {
          return this.exp.current
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
                             path: 'exp.current',
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
    left: 49%;
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
