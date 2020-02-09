<template>
  <div class="grid-suspicions">
    <div class="head-line" />
    <div class="inline-flex">
      <div>
        <div class="black">
          <span class="title">Подозрения</span>
        </div>
      </div>
      <div
        v-for="number in suspicions.max"
        :key="`suspicions-${number}`"
        class="button"
        @click="changeSuspicions(currentSuspicions < number)"
      >
        <div v-if="currentSuspicions >= number" class="full-black" />
        <div v-else>
          <div class="black-part" />
          <div class="empty-part" />
        </div>
      </div>
      <div class="inline-flex wanted">
        <div class="black wanted-block">
          <span class="title wanted-title">Розыск</span>
          <div class="wanted-marks">
            <div
              v-for="number in wanted.max"
              :key="`wanted-${number}`"
              :class="['button', wantedMarkClass(number)]"
              @click="changeWanted(currentWanted < number)"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'

  export default {
    name: 'Suspicions',
    props: {
      sheet: { type: Object, required: true },
    },

    data() {
      return {
        modalOpen: false,
      }
    },

    computed: {
      suspicions: {
        get() {
          return this.sheet.params.suspicions
        },
      },

      wanted: {
        get() {
          return this.sheet.params.wanted
        },
      },

      currentSuspicions: {
        get() {
          return this.suspicions.current
        },
      },

      currentWanted: {
        get() {
          return this.wanted.current
        },
      },
    },

    methods: {
      wantedMarkClass(number) {
        return this.currentWanted >= number ? 'black-mark' : 'white-mark'
      },

      changeSuspicions(isIncrement) {
        const value = this.currentSuspicions + (isIncrement ? 1 : -1)
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'suspicions.current',
                             value,
                           })

        this.saveSheet()
      },

      changeWanted(isIncrement) {
        const value = this.currentWanted + (isIncrement ? 1 : -1)
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'wanted.current',
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

  .grid-suspicions {
    display: grid;
    grid-template-columns: max-content;
    grid-template-rows: 5px max-content;
    margin-top: 10px;
  }

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

  .wanted {
    margin-left: -10px;
  }

  .wanted-block {
    width: 110px;
    height: 32px;
  }

  .wanted-title {
    margin-left: 16px;
  }

  .wanted-marks {
    display: inline-flex;
    margin-left: 10px;
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

  .black-mark {
    margin-right: 10px;
    width: 15px;
    height: 30px;
    background:
      linear-gradient(-45deg, transparent 15px, $black 0);
  }

  .white-mark {
    margin-right: 10px;
    width: 15px;
    height: 30px;
    background:
      linear-gradient(-45deg, transparent 15px, $white 0);
  }
</style>
