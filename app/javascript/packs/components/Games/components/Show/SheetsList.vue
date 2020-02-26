<template>
  <v-list>
    <v-list-item v-for="sheet in sheets" :key="sheet.id" class="list-item">
      <drag :transfer-data="{ sheet }" class="drag-part">
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

  import { ADD_OPEN_MODAL } from '../../stores/mutation-types'

  export default {
    name: 'SheetsList',

    computed: {
      ...mapState({
        sheets: state => state.game.sheets,
      }),
    },

    methods: {
      showSheet({ id, sheetType }) {
        const key = Date.now()
        this.$store.commit(ADD_OPEN_MODAL, { name: 'sheet', key, id, sheetType })
      },

      deleteSheet(id) {
        this.$store.dispatch('deleteSheet', id)
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
