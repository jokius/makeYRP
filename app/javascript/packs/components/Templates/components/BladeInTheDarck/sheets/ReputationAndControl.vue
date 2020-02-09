<template>
  <div class="grid-reputation">
    <div class="col1">
      <div class="head-line" />
      <div class="inline-flex">
        <div class="inline-flex">
          <div class="title-block">
            <div class="black inline-flex">
              <div class="button" @click="changeReputation(false)">-</div>
              <span class="title">Реп.</span>
              <div class="button" @click="changeReputation(true)">+</div>
            </div>
          </div>
          <div
            v-for="number in reputation.max"
            :key="`reputation-${number}`"
          >
            <div v-if="currentReputation >= number && currentReputation <= currentMaxReputation" class="full-black mr10" />
            <div v-else>
              <div v-if="number > currentMaxReputation" class="full-gray mr10" />
              <div v-else>
                <div :class="number > (reputation.max - territories.max) ? 'gray-part mr10' : 'black-part mr10'" />
                <div class="empty-part mr10" />
              </div>
            </div>
          </div>
          <div class="title-block">
            <div class="gray inline-flex">
              <div class="button" @click="changeTerritory(true)">+</div>
              <span class="title">Террит.</span>
              <div class="button" @click="changeTerritory(false)">-</div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="col2 inline-flex">
      <div class="with-line">
        <div class="head-line" />
        <div class="inline-flex">
          <div class="inline-flex">
            <div class="inline-flex title-block">
              <div class="black">
                <span class="title pad3">Контроль</span>
              </div>
              <div class="white">
                <span class="title pad3">Слабый</span>
              </div>
            </div>
            <div v-if="control === 'weak'" class="full-black pointer" />
            <div v-else @click="changeControl('weak')">
              <div class="black-part pointer" />
              <div class="empty-part pointer" />
            </div>
            <div class="inline-flex">
              <div class="white title-block">
                <span class="title pad3">Сильный</span>
              </div>
            </div>
            <div v-if="control === 'strong'" class="full-black pointer" />
            <div v-else @click="changeControl('strong')">
              <div class="black-part pointer" />
              <div class="empty-part pointer" />
            </div>
            <div class="title-block">
              <div class="black">
                <span class="title pad3">Рейтинг</span>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="rank inline-flex">
        <div
          v-for="number in rank.max"
          :key="`rank-${number}`"
          :class="fullBox(number)"
          @click="changeRank(currentRank < number)"
        />
      </div>
    </div>
  </div>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'

  export default {
    name: 'ReputationAndControl',
    props: {
      sheet: { type: Object, required: true },
    },

    data() {
      return {
        modalOpen: false,
      }
    },

    computed: {
      reputation: {
        get() {
          return this.sheet.params.reputation
        },
      },

      territories: {
        get() {
          return this.sheet.params.territories
        },
      },

      control: {
        get() {
          return this.sheet.params.control
        },
      },

      rank: {
        get() {
          return this.sheet.params.rank
        },
      },

      currentReputation: {
        get() {
          return this.reputation.current
        },
      },

      currentTerritories: {
        get() {
          return this.territories.current
        },
      },

      currentRank: {
        get() {
          return this.rank.current
        },
      },

      currentMaxReputation: {
        get() {
          return this.reputation.max - this.currentTerritories
        },
      },
    },

    methods: {
      changeReputation(isIncrement) {
        let value = this.currentReputation + (isIncrement ? 1 : -1)
        value = value > 0 ? value : 0
        value = value < this.currentMaxReputation ? value : this.currentMaxReputation

        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'reputation.current',
                             value,
                           })

        this.saveSheet()
      },

      changeTerritory(isIncrement) {
        let value = this.currentTerritories + (isIncrement ? 1 : -1)
        value = value > 0 ? value : 0
        value = value < this.territories.max ? value : this.territories.max

        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'territories.current',
                             value,
                           })

        this.saveSheet()
      },

      changeControl(value) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'control',
                             value,
                           })

        this.saveSheet()
      },

      fullBox(number) {
        return `circle ${this.currentRank >= number ? 'select' : 'not-select'}`
      },

      changeRank(isIncrement) {
        const value = this.currentRank + (isIncrement ? 1 : -1)
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'rank.current',
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

  .mr10 {
    margin-right: 10px;
  }

  .pad3 {
    padding: 3px;
  }

  .pointer {
    cursor: pointer;
  }

  .grid-reputation {
    display: grid;
    grid-template-columns: max-content max-content;
    grid-column-gap: 10px;
  }

  .head-line {
    background-color: $black;
    height: 5px;
    width: 100%;
  }

  .inline-flex {
    display: inline-flex;
  }

  .title-block {
    height: 30px;
  }

  .title {
    width: max-content;
    font-size: 1rem!important;
  }

  .button {
    cursor: pointer;
    margin-left: 10px;
    margin-right: 10px;
    font-size: 20px;
    position: relative;
  }

  .black {
    background-color: $black;
    color: $white;
  }

  .gray {
    background-color: $gray42;
    color: $black;
    margin-left: -10px;
  }

  .white {
    background-color: $white;
    color: $black;
  }

  .full-black {
    width: 15px;
    height: 60px;
    background:
      linear-gradient(-45deg, transparent 15px, $black 0);
  }

  .full-gray {
    width: 15px;
    height: 60px;
    background:
      linear-gradient(-45deg, transparent 15px, $gray42 0);
  }

  .black-part {
    width: 15px;
    height: 35px;
    background:
      linear-gradient(-45deg, transparent 15px, $black 0),
      linear-gradient(45deg, transparent 0, $white 0);
  }

  .gray-part {
    width: 15px;
    height: 35px;
    background:
      linear-gradient(-45deg, transparent 15px, $gray42 0),
      linear-gradient(45deg, transparent 0, $white 0);
  }

  .empty-part {
    width: 15px;
    height: 25px;
    background:linear-gradient(-45deg, transparent 15px, $white 0);
  }

  .circle {
    cursor: pointer;
    background-color: $white;
    width: 15px;
    height: 15px;
    border-radius: 50%;
    border: 1px solid $black;
    margin-top: 12px;
    margin-left: 5px;
  }

  .select {
    background: $black;
  }

  .not-select {
    background: $white;
  }
</style>
