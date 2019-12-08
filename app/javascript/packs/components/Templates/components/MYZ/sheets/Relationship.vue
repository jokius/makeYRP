<template>
  <div class="grid">
    <div class="grid-title">
      <span class="title">Взаимоотношения</span>
    </div>
    <div class="grid-body">
      <div class="grid-item headers">
        <span>Кто</span>
        <span>Отношение</span>
      </div>
      <div
        v-for="(item, index) in relationship"
        :key="`relationship-${index}`"
        class="grid-item"
      >
        <v-text-field
          :value="item.who"
          color="indigo"
          class="input"
          hide-details
          @input="value => input(index, 'who', value)"
          @change="saveSheet"
        />
        <v-text-field
          :value="item.attitude"
          color="indigo"
          class="input"
          hide-details
          @input="value => input(index, 'attitude', value)"
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
      <v-btn small @click="addRelationship">
        Добавить
      </v-btn>
    </div>
  </div>
</template>

<script>
  import { UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'

  export default {
    name: 'Relationship',
    props: {
      sheet: { type: Object, required: true },
    },

    computed: {
      relationship: {
        get() {
          return this.sheet.params.relationships
        },
      },
    },

    methods: {
      input(index, target, value) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `relationships.${index}.${target}`,
                             value: value,
                           })

      },

      remove(index) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'relationships',
                             value: index,
                             remove: true,
                           })

        this.saveSheet()
      },

      addRelationship() {
        const relation = {
          who: '',
          attitude: '',
        }

        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `relationships.${this.relationship.length}`,
                             value: relation,
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
    grid-template-columns: 1fr;
    background-image: url("../images/relationship.jpeg");
    background-size: cover;
    background-color: $orangeE9;
  }

  .grid-body {
    display: grid;
    grid-template-columns: 1fr;
    grid-row-gap: 2px;
  }

  .grid-item {
    display: grid;
    grid-template-columns: 200px 1fr 40px;
    grid-column-gap: 5px;
  }

  .headers {
    border-bottom: $border;
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
    background-color: $white;
  }

  .actions {
    display: grid;
    grid-template-columns: max-content auto max-content;
    grid-row-gap: 5px;
    margin: 5px;
  }
</style>
