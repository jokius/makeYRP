<template>
  <div class="grid">
    <div class="grid-title">
      <span class="title">Мутации</span>
    </div>
    <div class="grid-body">
      <div
        v-for="(item, index) in mutations"
        :key="item.key"
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
          @click="removeMutation(index)"
        >
          <v-icon>mdi-delete</v-icon>
        </v-btn>
      </div>
    </div>
    <div class="actions">
      <v-btn small @click="getMutation">
        Получить мутацию
      </v-btn>
      <span class="spacer" />
      <v-btn small @click="getMisfire">
        Получить отдачу
      </v-btn>
      <v-btn small @click="modalOpen = true">
        Задать вручную
      </v-btn>
    </div>
    <div class="misfires">
      <div v-for="(item, index) in misfires" :key="`misfires-${index}`">
        <div>{{ item }}</div>
        <v-btn small @click="removeMisfire(index)">
          Убрать отдачу
        </v-btn>
      </div>
    </div>
    <add-mutation-modal v-model="obj" />
  </div>
</template>

<script>
  import { mapState } from 'vuex'
  import { isEmpty } from 'lodash'

  import { ADD_OPEN_MODAL, UPDATE_SHEET_PARAMS } from '../../../../Games/stores/mutation-types'
  import { Myz } from '../../../../../lib/Myz'
  import AddMutationModal from '../modals/AddMutationModal'

  export default {
    name: 'Mutations',
    components: { AddMutationModal },
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

      mutations: {
        get() {
          return this.sheet.params.mutations
        },
      },

      misfires: {
        get() {
          return this.sheet.params.misfires
        },
      },

      obj: {
        get() {
          return { open: this.modalOpen, mutation: {} }
        },

        set({ open, mutation }) {
          this.setMutation(mutation)
          this.modalOpen = open
        },
      },
    },

    created() {
      let needSave = false

      this.mutations.forEach((item, index) => {
        if (item === '@random') {
          this.$store.commit(UPDATE_SHEET_PARAMS,
                             {
                               id: this.sheet.id,
                               path: `mutations.${index}`,
                               value: Myz.randomMutation(this.tables.mutations, this.mutations),
                             })
          needSave = true
        }
      })

      if (needSave) this.saveSheet()
    },

    methods: {
      getMutation() {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `mutations.${this.mutations.length}`,
                             value: Myz.randomMutation(this.tables.mutations, this.mutations),
                           })

        this.saveSheet()
      },

      setMutation(mutation) {
        if (isEmpty(mutation)) return

        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `mutations.${this.mutations.length}`,
                             value: mutation,
                           })

        this.saveSheet()
      },

      getMisfire() {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: `misfires.${this.misfires.length}`,
                             value: Myz.randomMisfire(this.tables.misfires),
                           })

        this.saveSheet()
      },

      removeMisfire(index) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'misfires',
                             value: index,
                             remove: true,
                           })

        this.saveSheet()
      },

      removeMutation(index) {
        this.$store.commit(UPDATE_SHEET_PARAMS,
                           {
                             id: this.sheet.id,
                             path: 'mutations',
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

      showInfo(mutation) {
        const key = Date.now()
        let description = mutation.description
        description += '<div>Способы использования:</div><ul>'
        let useCases = ''
        mutation.use_cases.forEach(useCase => {
          let mode = ''
          if (useCase.reactive) {
            mode = '(О)'
          } else if (useCase.enhancing) {
            mode = '(У)'
          }

          useCases += `
            <li>
              <div class="MYZ-mutationsUseDescription">
                ${useCase.description}
              </div>
              <div class="MYZ-mutationsUsePrice">
                <span>Стоимость:</span>
                <span>${useCase.price}</span>
                <span>${mode}</span>
              </div>
            </li>
          `
        })
        description += `${useCases}</ul>`

        this.$store.commit(ADD_OPEN_MODAL, { name: 'info', key, title: mutation.name, description })
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
    background-image: url("../images/mutations.jpeg");
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

  .actions {
    display: grid;
    grid-template-columns: max-content auto max-content;
    grid-row-gap: 5px;
    margin: 5px;
  }
</style>
