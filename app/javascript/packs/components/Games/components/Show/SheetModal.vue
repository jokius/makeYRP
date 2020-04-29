<template>
  <draggable-dialog
    v-model="size"
    :on-close="onClose"
    :title="sheet.name"
    :width="size.width + 2"
    :height="size.height + 40"
    resizable
  >
    <template v-slot:body>
      <mutant-sheet v-if="sheetName === 'mutant_year_zero-mutant'" :id="id" :key="key" :size="size"/>
      <bid-character-sheet v-else-if="sheetName === 'blade_in_the_dark-character'" :id="id" :key="key" :size="size"/>
      <bid-team-sheet v-else-if="sheetName === 'blade_in_the_dark-team'" :id="id" :key="key" :size="size"/>
      <hmw-character-sheet
        v-else-if="sheetName === 'horror_movie_world-character'"
        :id="id"
        :key="key"
        :size="size"
      />
      <hmw-monster-sheet
        v-else-if="sheetName === 'horror_movie_world-monster'"
        :id="id"
        :key="key"
        :size="size"
      />
      <eou-character-sheet
        v-else-if="sheetName === 'edge_of_universe-character'"
        :id="id"
        :key="key"
        :size="size"
      />
      <eou-enemy-sheet
        v-else-if="sheetName === 'edge_of_universe-enemy'"
        :id="id"
        :key="key"
        :size="size"
      />
      <v-alert
        v-else
        :key="key"
        v-model="alert"
        dismissible
        class="alert"
        type="error"
      >
        {{ sheetName }} не существует
      </v-alert>
    </template>
  </draggable-dialog>
</template>

<script>
  import { mapState } from 'vuex'

  import DraggableDialog from './DraggableDialog'

  import MutantSheet from '../../../Templates/components/MYZ/sheets/MutantSheet'
  import BidCharacterSheet from '../../../Templates/components/BladeInTheDarck/sheets/CharacterSheet'
  import BidTeamSheet from '../../../Templates/components/BladeInTheDarck/sheets/TeamSheet'
  import HmwCharacterSheet from '../../../Templates/components/pbta/HorrorMovieWorld/sheets/CharacterSheet'
  import HmwMonsterSheet from '../../../Templates/components/pbta/HorrorMovieWorld/sheets/MonsterSheet'
  import EouCharacterSheet from '../../../Templates/components/pbta/EdgeOfUniverse/sheets/CharacterSheet'
  import EouEnemySheet from '../../../Templates/components/pbta/EdgeOfUniverse/sheets/EnemySheet'
  import { DELETE_SHEET, REMOVE_OPEN_MODAL, UPDATE_SHEET } from '../../stores/mutation-types'

  export default {
    name: 'SheetModal',
    components: {
      EouEnemySheet,
      MutantSheet,
      BidCharacterSheet,
      BidTeamSheet,
      DraggableDialog,
      HmwCharacterSheet,
      HmwMonsterSheet,
      EouCharacterSheet,
    },

    props: {
      uniqKey: { type: Number, required: true },
      id: { type: Number, required: true },
      sheetType: { type: String, required: true },
    },

    data() {
      return {
        privateWidth: null,
        privateHeight: null,
      }
    },

    channels: {
      SheetChannel: {
        received(obj) {
          if (obj.delete) {
            this.$cable.unsubscribe('SheetChannel')
            this.onClose()
            this.$store.commit(DELETE_SHEET, obj.delete)
          } else {
            this.$store.commit(UPDATE_SHEET, obj)
          }
        },
      },
    },

    computed: {
      ...mapState({
        game: state => state.game.info,
        sheets: state => state.game.sheets,
      }),

      sheet: {
        get() {
          return this.sheets.find(sheet => sheet.id === this.id)
        },
      },

      sheetName: {
        get() {
          return `${this.game.system}-${this.sheetType}`
        },
      },

      key: {
        get() {
          return `${this.sheetName}-${this.id}`
        },
      },

      size: {
        get() {
          switch (this.sheetName) {
            case 'mutant_year_zero-mutant':
              return { width: this.privateWidth || 950, height: this.privateHeight || 600 }
            case 'blade_in_the_dark-character':
              return { width: this.privateWidth || 950, height: this.privateHeight || 600 }
            case 'blade_in_the_dark-team':
              return { width: this.privateWidth || 950, height: this.privateHeight || 600 }
            case 'horror_movie_world-character':
              return { width: this.privateWidth || 950, height: this.privateHeight || 600 }
            case 'horror_movie_world-monster':
              return { width: this.privateWidth || 950, height: this.privateHeight || 600 }
            case 'edge_of_universe-character':
              return { width: this.privateWidth || 950, height: this.privateHeight || 600 }
            case 'edge_of_universe-enemy':
              return { width: this.privateWidth || 950, height: this.privateHeight || 600 }
            default:
              return { width: this.privateWidth || 950, height: this.privateHeight || 600 }
          }
        },

        set({ width, height }) {
          this.privateWidth = width
          this.privateHeight = height
        },
      },
    },

    mounted() {
      this.$cable.subscribe({
        channel: 'SheetChannel',
        sheet_id: this.id,
      })
    },

    methods: {
      onClose() {
        this.$store.commit(REMOVE_OPEN_MODAL, this.uniqKey)
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .whiteText {
    color: $white;
  }
</style>
