<template>
  <div class="grid">
    <div class="grid-title">
      <span class="title">Внешний вид</span>
    </div>
    <div class="grid-body">
      <v-text-field
        v-model="face"
        color="indigo"
        class="input"
        hide-details
        label="Лицо"
        @change="saveSheet"
      />
      <v-text-field
        v-model="body"
        color="indigo"
        class="input"
        hide-details
        label="Тело"
        @change="saveSheet"
      />
      <v-text-field
        v-model="clothing"
        color="indigo"
        class="input"
        hide-details
        label="Одежда"
        @change="saveSheet"
      />
    </div>
  </div>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'

  export default {
    name: 'Appearance',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      face: {
        get() {
          return this.sheet.params.info.face
        },

        set(value) {
          this.input('face', value)
        },
      },

      body: {
        get() {
          return this.sheet.params.info.body
        },

        set(value) {
          this.input('body', value)
        },
      },

      clothing: {
        get() {
          return this.sheet.params.info.clothing
        },

        set(value) {
          this.input('clothing', value)
        },
      },
    },

    methods: {
      input(target, value) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `info.${target}`,
                             value: value,
                           })

      },

      saveSheet() {
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
    background-image: url("../images/appearance.jpeg");
    background-size: cover;
    background-color: $orangeE9;
  }

  .grid-body {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    grid-column-gap: 5px;
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
