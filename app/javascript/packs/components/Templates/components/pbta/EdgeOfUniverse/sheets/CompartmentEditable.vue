<template>
  <div class="compartment-block">
    <div class="title-compartment">
      <v-text-field
        v-model="name"
        color="black"
        class="input name"
        flat
        hide-details
        dark
        @change="saveSheet"
      />
      <v-spacer />
      <div
        :class="[{ enable: damaged }, 'box']"
        @click="input('damaged', !damaged)"
      />
      <span>Поврежден</span>
    </div>

    <details>
      <summary class="pointer">
        Подробнее
      </summary>
      <v-textarea
        v-model="description"
        auto-grow
        no-resize
        rows="2"
        color="indigo"
        background-color="white"
        class="notes"
        hide-details
        @change="saveSheet"
      />
      <div class="tags-grid">
        <span class="label tag-label">Теги</span>
        <v-chip-group>
          <v-chip
            v-for="(tag, tagIndex) in tags"
            :key="`tag-${tagIndex}`"
            close
            @click:close="removeTag(tagIndex)"
          >
            {{ tag }}
          </v-chip>
        </v-chip-group>

        <v-btn
          class="tag-button"
          dark
          small
          @click="modalOpen = true"
        >
          <v-icon dark>mdi-plus</v-icon>
        </v-btn>
      </div>
    </details>

    <add-tag-modal v-model="obj" />
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import { UPDATE_SHEET_PARAMS } from '../../../../../Games/stores/mutation-types'
  import AddTagModal from '../modals/AddTagModal'

  export default {
    name: 'CompartmentEditable',
    components: { AddTagModal },
    props: {
      compartment: { type: Object, required: true },
      index: { type: Number, required: true },
      path: { type: String, required: true },
      sheet: { type: Object, required: true },
    },

    computed: {
      ...mapState({
        sheets: state => state.game.sheets,
      }),

      damaged: {
        get() {
          return this.compartment.damaged
        },
      },

      name: {
        get() {
          return this.compartment.name
        },

        set(value) {
          return this.input('enable', value)
        },
      },

      description: {
        get() {
          return this.compartment.description
        },

        set(value) {
          return this.input('description', value)
        },
      },

      tags: {
        get() {
          return this.compartment.tags
        },
      },

      obj: {
        get() {
          return { open: this.modalOpen, tag: '' }
        },

        set({ open, tag, isClose }) {
          if (!isClose) this.addTag(tag)
          this.modalOpen = open
        },
      },
    },

    methods: {
      addTag(tag) {
        if (!tag) return

        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `${this.path}[${this.index}].tags[${this.tags.length}]`,
                             value: tag,
                           })

        this.saveSheet()
      },

      removeTag(value) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `${this.path}[${this.index}].tags`,
                             value,
                             remove: true,
                           })
        this.saveSheet()
      },

      input(target, value) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `${this.path}[${this.index}].${target}`,
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

  .compartment-block {
    margin-bottom: 5px;
  }

  .title-compartment {
    display: grid;
    grid-template-columns: max-content 1fr 30px max-content;
    grid-column-gap: 5px;
    background-color: $black;
    color: $white;
    height: 35px;
    line-height: 35px;
    margin-left: -5px;
    padding-right: 10px;
  }

  .pointer {
    cursor: pointer;
  }

  .input {
    padding: 0;
    margin: 0;
  }

  .box {
    cursor: pointer;
    width: 20px;
    height: 20px;
    margin-left: 5px;
    margin-top: 7px;
    border: 2px solid $white;
  }

  .enable {
    background-color: $white;
    border: 2px solid $black;
  }

  .compartment-name {
    margin-left: 5px;
    font-weight: 600;
  }
</style>
