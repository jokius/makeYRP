<template>
  <v-list>
    <v-list-item v-for="sheet in sheets" :key="sheet.id" class="list-item">
      <drag :transfer-data="{ sheet }" class="drag-part">
        <right-click-menu :position="position" :current-obj="sheetObj(sheet)">
          <div
            :style="baseStyle"
            class="pointer"
            @contextmenu="handler($event, sheet)"
          >
            <v-list-item-avatar size="24" color="indigo">
              <v-img
                v-if="sheet.imgChat"
                :src="sheet.imgChat"
                :alt="sheet.name"
                @click="showSheet(sheet)"
              />
              <v-icon
                v-else
                dark
                :title="sheet.name"
                @click="showSheet(sheet)"
              >
                mdi-account-circle
              </v-icon>
            </v-list-item-avatar>
            <v-list-item-content>
              <v-list-item-title
                class="pointer"
                @click="showSheet(sheet)"
                v-text="sheet.name"
              />
            </v-list-item-content>
          </div>
        </right-click-menu>
      </drag>
      <v-list-item-icon>
        <v-btn
          color="red darken-4"
          fab
          x-small
          dark
          @click="deleteSheet(sheet.id)"
        >
          <v-icon>mdi-delete</v-icon>
        </v-btn>
      </v-list-item-icon>
    </v-list-item>
  </v-list>
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
  .pointer {
    cursor: pointer;
  }

  .list-item {
    display: grid;
    grid-template-columns: 1fr max-content;
  }

  .drag-part {
    display: inline-flex;
  }
</style>
