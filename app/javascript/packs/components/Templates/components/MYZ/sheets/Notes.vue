<template>
  <div class="grid">
    <div class="grid-title">
      <span class="title">Заметки</span>
    </div>
    <div class="grid-body">
      <v-textarea
        v-model="notes"
        auto-grow
        no-resize
        rows="2"
        color="indigo"
        class="input"
        hide-details
        label="Заметки"
        @change="saveSheet"
      />
    </div>
  </div>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'

  export default {
    name: 'Notes',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      notes: {
        get() {
          return this.sheet.params.info.notes
        },

        set(value) {
          this.input('notes', value)
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
    margin-right: 5px;
  }

  .grid-title {
    display: grid;
    grid-template-columns: 1fr;
    background-image: url("../images/talents.jpeg");
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
