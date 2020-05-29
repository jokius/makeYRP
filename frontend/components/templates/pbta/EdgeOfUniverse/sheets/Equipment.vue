<template>
  <div class="equipment-grid">
    <div class="title-equipment">
      <div :class="[{ enable }, 'box']" @click="changeEquipment(!enable)" />
      <v-text-field
        v-if="edit"
        v-model="name"
        color="black"
        class="input"
        dark
        flat
        @change="saveSheet"
      />
      <span v-else class="equipment-name">{{ name }}</span>
      <span class="equipment-remove" @click="removeEquipment">Удалить</span>
    </div>

    <details>
      <summary class="pointer">
        Подробнее
      </summary>

      <div class="markers-grid">
        <div class="input-grid">
          <span class="label">Количество</span>
          <v-text-field
            v-model.number="quantity"
            color="indigo"
            class="input"
            flat
            type="number"
            hide-details
            @change="saveSheet"
          />
        </div>

        <div v-if="damage || edit" class="input-grid">
          <span class="label">Урон</span>
          <v-text-field
            v-model.number="damage"
            color="indigo"
            class="input"
            flat
            type="number"
            hide-details
            @change="saveSheet"
          />
        </div>

        <div v-if="protection || edit" class="input-grid">
          <span class="label">Защита</span>
          <v-text-field
            v-model.number="protection"
            color="indigo"
            class="input"
            flat
            type="number"
            hide-details
            @change="saveSheet"
          />
        </div>
      </div>

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
      <v-textarea
        v-if="edit"
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
      <span v-else class="equipment-description">{{ description }}</span>
    </details>

    <add-tag-modal v-model="obj" />
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import AddTagModal from '../modals/AddTagModal'

  export default {
    name: 'Equipment',
    components: { AddTagModal },
    props: {
      item: { type: Object, required: true },
      path: { type: String, required: true },
      index: { type: Number, required: true },
      sheet: { type: Object, required: true },
    },

    data() {
      return {
        privateType: {},
        modalOpen: false,
      }
    },

    computed: {
      ...mapState({
        sheets: state => state.game.sheets,
        tables: state => state.game.info.template.tables,
      }),

      enable: {
        get() {
          return this.item.enable
        },
      },

      edit: {
        get() {
          return this.item.edit
        },
      },

      name: {
        get() {
          return this.item.name
        },

        set(value) {
          this.input('name', value)
        },
      },

      quantity: {
        get() {
          return this.item.quantity
        },

        set(value) {
          this.input('quantity', value)
        },
      },

      damage: {
        get() {
          return this.item.damage
        },

        set(value) {
          this.input('damage', value)
        },
      },

      protection: {
        get() {
          return this.item.protection
        },

        set(value) {
          this.input('protection', value)
        },
      },

      description: {
        get() {
          return this.item.description
        },

        set(value) {
          this.input('description', value)
        },
      },

      tags: {
        get() {
          return this.item.tags
        },

        set(value) {
          this.input('tags', value)
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

      changeEquipment(value) {
        this.input('enable', value)
        this.saveSheet()
      },

      removeEquipment() {
        this.$store.commit('game/updateSheetParams',
                           {
                             id: this.sheet.id,
                             path: this.path,
                             value: this.index,
                             remove: true,
                           })
        this.saveSheet()
      },

      addTag(tag) {
        if (!tag) return

        this.$store.commit('game/updateSheetParams',
                           {
                             id: this.sheet.id,
                             path: `${this.path}[${this.index}].tags[${this.tags.length}]`,
                             value: tag,
                           })

        this.saveSheet()
      },

      removeTag(value){
        this.$store.commit('game/updateSheetParams',
                           {
                             id: this.sheet.id,
                             path: `${this.path}[${this.index}].tags`,
                             value,
                             remove: true,
                           })
        this.saveSheet()
      },

      input(target, value) {
        this.$store.commit('game/updateSheetParams',
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
  @import '~assets/css/colors';

  .equipment-grid {
    display: grid;
    margin-bottom: 5px;
    background-color: $grayC5;
  }

  .pointer {
    cursor: pointer;
  }

  .title-equipment {
    display: grid;
    grid-template-columns: 30px 1fr max-content;
    background-color: $black;
    color: $white;
    height: 35px;
    line-height: 35px;
    margin-left: -5px;
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

  .equipment-name {
    margin-left: 5px;
    font-size: 18px;
    font-weight: 600;
  }

  .equipment-remove {
    cursor: pointer;
    margin-right: 10px;
  }

  .markers-grid {
    display: grid;
    grid-template-columns: repeat(4, max-content);
    grid-column-gap: 10px;
  }

  .input-grid {
    display: grid;
    grid-template-columns: max-content 50px;
    grid-column-gap: 10px;
    height: 35px;
    line-height: 35px;
  }

  .tags-grid {
    display: grid;
    grid-template-columns: repeat(3, max-content);
    grid-column-gap: 10px;
    height: 35px;
    line-height: 35px;
  }

  .input {
    padding: 0;
    margin: 0;
  }

  .tag-label {
    margin-top: 5px;
  }

  .tag-button {
    margin-top: 10px;
  }
</style>
