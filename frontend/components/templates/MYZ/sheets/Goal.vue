<template>
  <div class="grid">
    <div class="grid-title">
      <span class="title">Моя цель</span>
    </div>
    <div class="grid-body">
      <v-textarea
        v-model="goal"
        auto-grow
        no-resize
        rows="2"
        color="indigo"
        class="input"
        hide-details
        label="Цель"
        @change="saveSheet"
      />
    </div>
  </div>
</template>

<script>
  export default {
    name: 'Goal',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      goal: {
        get() {
          return this.sheet.params.info.goal
        },

        set(value) {
          this.input('goal', value)
        },
      },
    },

    methods: {
      input(target, value) {
        this.$store.commit('game/updateSheetParams',
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
  @import '~assets/css/colors';

  $title_height: 35px;

  .grid {
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: $title_height max-content;
  }

  .grid-title {
    display: grid;
    grid-template-columns: 1fr;
    background-image: url("/images/MYZ/talents.jpeg");
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
