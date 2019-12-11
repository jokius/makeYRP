<template>
  <div class="grid">
    <div
      v-for="(item, index) in counters"
      :key="item.target"
      class="grid-item"
    >
      <span class="text">{{ item.name }}</span>
      <v-text-field
        :value="item.current"
        color="indigo"
        class="input"
        type="number"
        :min="item.min"
        :max="item.max"
        @input="value => change(index, value)"
      />
    </div>
  </div>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'

  export default {
    name: 'Counters',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      counters: {
        get() {
          return this.sheet.params.counters
        },
      },
    },

    methods: {
      change(target, value) {
        const intVal = parseInt(value, 10) || value
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `counters.${target}.current`,
                             value: intVal,
                           })

        if (value && value !== '')
          this.$store.dispatch('saveSheet', this.sheet)
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  $title_height: 35px;

  .grid {
    display: flex;
    flex-flow: wrap;
    padding-left: 5px;
    padding-bottom: 3px;
  }

  .grid-item {
    display: grid;
    grid-template-columns: max-content 50px;
    grid-template-rows: $title_height;
    grid-column-gap: 5px;
    margin-left: 10px;
    margin-bottom: 5px;
  }

  .text {
    vertical-align: middle;
    line-height: $title_height;
  }

  .input {
    padding: 0;
    margin: 0;
    background-color: $white;
    border: 1px solid $black;
  }
</style>
