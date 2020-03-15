<template>
  <div class="grid">
    <div class="grid-title">
      <span class="title">Достоинства</span>
    </div>
    <div class="grid-body">
      <div
        v-for="(item, index) in talents"
        :key="`talent-${index}`"
        class="grid-item"
      >
        <span class="text">{{ item.name }}</span>
        <v-btn
          icon
          @click="showInfo(item)"
        >
          <v-icon>mdi-notebook</v-icon>
        </v-btn>
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
    <v-btn small class="action" @click="modalOpen = true">
      Добавить достоинство
    </v-btn>
    <add-talent-modal v-model="obj" :role="sheet.params.info.role" />
  </div>
</template>

<script>
  import { mapState } from 'vuex'
  import { isEmpty } from 'lodash'

  import { ADD_OPEN_MODAL, UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'
  import AddTalentModal from '../modals/AddTalentModal'

  export default {
    name: 'Talents',
    components: { AddTalentModal },
    props: {
      sheet: { type: Object, required: true },
    },

    data() {
      return {
        modalOpen: false,
      }
    },

    computed: {
      ...mapState({
        tables: state => state.game.info.template.tables,
      }),

      talents: {
        get() {
          return this.sheet.params.talents
        },
      },

      obj: {
        get() {
          return { open: this.modalOpen, talent: {} }
        },

        set({ open, talent }) {
          this.setTalent(talent)
          this.modalOpen = open
        },
      },
    },

    methods: {
      setTalent(talent) {
        if (isEmpty(talent)) return

        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `talents.${this.talents.length}`,
                             value: talent,
                           })

        this.saveSheet()
      },

      remove(index) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'talents',
                             value: index,
                             remove: true,
                           })

        this.saveSheet()
      },

      saveSheet() {
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'change',
          data: { ...this.sheet, type: 'sheet' },
        })
      },

      showInfo({ name, description }) {
        const key = Date.now()
        this.$store.commit(ADD_OPEN_MODAL, { name: 'info', key, title: name, description })
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
    background-image: url("../images/talents.jpeg");
    background-size: cover;
    background-color: $orangeE9;
  }

  .grid-body {
    display: grid;
    grid-template-columns: 1fr;
    grid-row-gap: 5px;
    border-bottom: 1px solid $black;
  }

  .grid-item {
    display: grid;
    grid-template-columns: 1fr repeat(2, 24px);
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

  .action {
    margin: 5px;
  }
</style>
