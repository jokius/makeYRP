<template>
  <div class="grid">
    <div class="grid-title">
      <span class="title">Характеристики</span>
      <v-icon class="dice">mdi-biohazard</v-icon>
    </div>
    <div class="grid-body">
      <div
        v-for="(item, index) in stats"
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
        <span class="text">{{ item.damage.name }}</span>
        <v-text-field
          :value="item.damage.current"
          color="indigo"
          class="input"
          type="number"
          :min="item.damage.min"
          :max="item.current || 0"
          @input="value => change(`${index}.damage`, value)"
        />
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'Attributes',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      stats: {
        get() {
          return this.sheet.params.stats
        },
      },
    },

    methods: {
      change(target, value) {
        const intVal = parseInt(value, 10) || value
        this.$store.commit('game/updateSheetParams',
                           {
                             id: this.sheet.id,
                             path: `stats.${target}.current`,
                             value: intVal,
                           })

        if (value && value !== '')
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
    grid-template-columns: 1fr max-content;
    background-image: url("/images/MYZ/attributes.jpeg");
    background-size: cover;
    background-color: $orangeE9;
  }

  .grid-body {
    display: grid;
    grid-template-columns: 1fr;
    grid-row-gap: 3px;
    padding-left: 5px;
    padding-bottom: 3px;
  }

  .grid-item {
    display: grid;
    grid-template-columns: repeat(2, 1fr 66px);
    grid-template-rows: $title_height;
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

  .text {
    vertical-align: middle;
    line-height: $title_height;
  }

  .dice {
    margin-top: 3px;
    width: 30px;
    height: 30px;
    background-color: yellow;
    border-radius: 8px;
    color: $black;
  }

  .input {
    padding: 0;
    margin: 0;
    background-color: $white;
    border: 1px solid $black;
  }
</style>
