<template>
  <div class="grid">
    <div class="grid-title">
      <span class="title">Моя берлога</span>
    </div>
    <div class="grid-body">
      <v-textarea
        v-model="description"
        auto-grow
        no-resize
        rows="2"
        color="indigo"
        class="input"
        hide-details
        label="Описание"
        @change="saveSheet"
      />
      <v-textarea
        v-model="gearStashed"
        auto-grow
        no-resize
        rows="2"
        color="indigo"
        class="input"
        hide-details
        label="Спрятанное снаряжение в берлоге"
        @change="saveSheet"
      />
    </div>
  </div>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'

  export default {
    name: 'Den',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      description: {
        get() {
          return this.sheet.params.info.den.description
        },

        set(value) {
          this.input('description', value)
        },
      },

      gearStashed: {
        get() {
          return this.sheet.params.info.den.gear_stashed
        },

        set(value) {
          this.input('gear_stashed', value)
        },
      },
    },

    methods: {
      input(target, value) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `info.den.${target}`,
                             value: value,
                           })

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

  $title_height: 35px;

  .grid {
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: $title_height max-content;
  }

  .grid-title {
    display: grid;
    grid-template-columns: 1fr;
    background-image: url("../images/armor.jpeg");
    background-size: cover;
    background-color: $orangeE9;
  }

  .grid-body {
    display: grid;
    grid-template-columns: 1fr;
  }

  .title {
    font-size: 2.5rem;
    font-weight: bold;
    color: $white;
    padding-left: 5px;
    vertical-align: middle;
    line-height: $title_height;
  }

  .input {
    background-color: $white;
  }
</style>
