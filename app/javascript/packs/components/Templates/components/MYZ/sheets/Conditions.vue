<template>
  <div class="grid">
    <div class="grid-title">
      <span class="title">Состояния</span>
    </div>
    <div class="grid-body">
      <v-checkbox
        v-for="(item, index) in conditions"
        :key="item.target"
        :input-value="item.status"
        :label="item.name"
        color="indigo"
        class="input"
        @change="value => change(index, value)"
      />
    </div>
    <ul class="info">
      <li v-for="(info, index) in conditionsInfo" :key="`info-${index}`">
        {{ info }}
      </li>
    </ul>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'

  export default {
    name: 'Conditions',
    props: {
      sheet: { type: Object, required: true },
    },

    data() {
      return {
        conditionsInfo: [],
      }
    },

    computed: {
      ...mapState({
        tables: state => state.game.info.template.tables,
      }),

      conditions: {
        get() {
          return this.sheet.params.conditions
        },
      },
    },

    created() {
      this.buildInfo()
    },

    methods: {
      buildInfo() {
        let list = []
        this.conditions.forEach(condition => {
          if (condition.status) {
            list = list.concat(this.tables[condition.target] || [])
          }
        })

        this.conditionsInfo = list
      },

      change(target, value) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `conditions.${target}.status`,
                             value: value,
                           })

        this.buildInfo()
        this.$store.dispatch('saveSheet', this.sheet)
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  $title_height: 35px;

  .grid {
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: $title_height max-content;
  }

  .grid-title {
    display: grid;
    grid-template-columns: 1fr;
    background-image: url("../images/conditions.jpeg");
    background-size: cover;
    background-color: $orangeE9;
  }

  .grid-body {
    display: grid;
    grid-template-columns: 1fr 1fr;
    grid-auto-rows: 40px;
    grid-row-gap: 3px;
    padding-left: 5px;
  }

  .title {
    font-size: 2.5rem;
    font-weight: bold;
    color: $white;
    padding-left: 5px;
    vertical-align: middle;
    line-height: $title_height;
  }

  .info {
    padding-right: 2px;
  }

  .input {
    padding: 0;
    margin: 0;
  }
</style>
