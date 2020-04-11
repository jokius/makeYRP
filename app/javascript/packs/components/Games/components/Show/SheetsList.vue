<template>
  <div class="list">
    <div v-for="sheet in sheets" :key="sheet.id" class="list-item">
      <drag :transfer-data="{ sheet }">
        <div class="pointer" @click="showSheet(sheet)">
          <right-click-menu :position="position" :current-obj="sheetObj(sheet)" :acl="sheet.acl">
            <div
              :style="baseStyle"
              class="drag-part"
              @contextmenu="handler($event, sheet)"
            >
              <v-avatar color="indigo" size="32" tile>
                <v-img
                  v-if="sheet.imgChat"
                  :src="sheet.imgChat"
                  :alt="sheet.name"
                />
              </v-avatar>
              <div class="sheet-name">
                {{ sheet.name }}
              </div>
            </div>
          </right-click-menu>
        </div>
      </drag>
      <v-btn
        v-if="sheet.acl.canFull"
        color="red darken-4"
        icon
        small
        dark
        class="delete-button"
        @click="deleteSheet(sheet.id)"
      >
        <v-icon>mdi-delete</v-icon>
      </v-btn>
    </div>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import RightClickMenu from './RightClickMenu'

  import { ADD_OPEN_MODAL, UPDATE_CURRENT_RIGHT_CLICK_MENU } from '../../stores/mutation-types'
  import { mousePosition } from '../../../../lib/mousePosition'

  export default {
    name: 'SheetsList',
    components: { RightClickMenu },

    data: () => ({
      position: {
        x: 0,
        y: 0,
      },
    }),

    computed: {
      ...mapState({
        sheets: state => state.game.sheets,
      }),

      baseStyle: {
        get() {
          let flexDirection = 'row'
          switch (this.titlePosition) {
            case 'top':
              flexDirection = 'column'
              break
            case 'bottom':
              flexDirection = 'column-reverse'
              break
            case 'right':
              flexDirection = 'row-reverse'
              break
            default:
              break
          }

          return { display: 'flex', flexDirection }
        },
      },
    },

    methods: {
      handler(e, sheet) {
        this.position = mousePosition(e)
        this.$store.commit(UPDATE_CURRENT_RIGHT_CLICK_MENU, `sheet-${sheet.id}`)
        e.preventDefault()
      },

      showSheet({ id, sheetType }) {
        const key = Date.now()
        this.$store.commit(ADD_OPEN_MODAL, { name: 'sheet', key, id, sheetType })
      },

      deleteSheet(id) {
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'remove',
          data: { id, type: 'sheet' },
        })
      },

      sheetObj(sheet) {
        return {
          type: 'sheet',
          id: sheet.id,
        }
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .pointer {
    cursor: pointer;
  }

  .list {
    display: grid;
    grid-row-gap: 2px;
  }

  .list-item {
    display: grid;
    grid-template-columns: 1fr max-content;
    background-color: $grayEE;
  }

  .drag-part {
    display: grid;
    grid-template-columns: max-content 1fr;
  }

  .sheet-name {
    font-size: 16px;
    text-align: center;
    line-height: 32px;
    height: 32px;
    width: 100%;
  }

  .delete-button {
    text-align: center;
    line-height: 32px;
    height: 32px;
  }
</style>
