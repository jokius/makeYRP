<template>
  <div>
    <i>{{ name }}</i>
    <div>{{ hint }}</div>
    <v-textarea
      v-model="current"
      auto-grow
      no-resize
      rows="3"
      color="indigo"
      background-color="white"
      class="input"
      hide-details
      @change="saveSheet"
    />
  </div>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'

  export default {
    name: 'SpecialPlaces',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      specialPlaces: {
        get() {
          return this.sheet.params.specialPlaces
        },
      },

      name: {
        get() {
          return this.specialPlaces.name
        },
      },

      current: {
        get() {
          return this.specialPlaces.current
        },

        set(value) {
          this.$store.commit(UPDATE_SHEET_PARAMS,
                             {
                               id: this.sheet.id,
                               path: `specialPlaces.current`,
                               value,
                             })
        },
      },

      hint: {
        get() {
          return this.specialPlaces.hints.join(' - ')
        },
      },
    },

    methods: {
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
  .input {
    padding: 0;
    margin: 0 0 3px;
  }
</style>
