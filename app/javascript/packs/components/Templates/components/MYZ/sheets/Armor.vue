<template>
  <div class="grid">
    <div class="grid-title">
      <span class="title">Броня и щит</span>
      <img class="dice" src="../images/explosion.png" alt="кубик снаряжения" />
    </div>
    <div class="grid-body">
      <div class="grid-item headers">
        <span>Название</span>
        <span>КЗ</span>
      </div>
      <div
        v-for="(item, index) in armor"
        :key="`armor-${index}`"
        class="grid-item"
      >
        <v-text-field
          :value="item.name"
          color="indigo"
          class="input"
          hide-details
          @input="value => input(index, 'name', value)"
          @change="saveSheet"
        />
        <v-text-field
          :value="item.rating"
          color="indigo"
          class="input"
          hide-details
          type="number"
          @input="value => input(index, 'rating', parseInt(value, 10) || null)"
          @change="saveSheet"
        />
        <v-btn
          color="red darken-4"
          icon
          dark
          @click="remove(index)"
        >
          <v-icon>mdi-delete</v-icon>
        </v-btn>
      </div>
    </div>
    <div class="actions">
      <v-btn small @click="addArmor">
        Добавить
      </v-btn>
    </div>
  </div>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'

  export default {
    name: 'Armor',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      armor: {
        get() {
          return this.sheet.params.armor
        },
      },
    },

    methods: {
      input(index, target, value) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `armor.${index}.${target}`,
                             value: value,
                           })

      },

      remove(index) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'armor',
                             value: index,
                             remove: true,
                           })

        this.saveSheet()
      },

      addArmor() {
        const item = {
          name: '',
          rating: 0,
        }

        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `armor.${this.armor.length}`,
                             value: item,
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

  $title_height: 35px;
  $border: 1px solid $black;

  .grid {
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: $title_height max-content;
  }

  .grid-title {
    display: grid;
    grid-template-columns: 1fr max-content;
    background-image: url("../images/armor.jpeg");
    background-size: cover;
    background-color: $orangeE9;
  }

  .grid-body {
    display: grid;
    grid-template-columns: 1fr;
  }

  .grid-item {
    display: grid;
    grid-template-columns: 455px 50px 40px;
  }

  .headers {
    border-bottom: $border;
  }

  .dice {
    margin-top: 3px;
    width: 30px;
    height: 30px;
    background-color: $black;
    border-radius: 8px;
    margin-right: 2px;
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

  .input {
    margin: 0;
    padding: 3px 0 0;
    border-right: $border;
    background-color: $white;
  }

  .actions {
    display: grid;
    grid-template-columns: max-content auto max-content;
    grid-row-gap: 5px;
    margin: 5px;
  }
</style>
