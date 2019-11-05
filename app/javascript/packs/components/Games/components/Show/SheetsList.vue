<template>
  <v-list>
    <v-list-item
      v-for="sheet in sheets"
      :key="sheet.id"
    >
      <v-list-item-avatar size="24" color="indigo">
        <img
          v-if="sheet.avatar"
          :src="sheet.avatar"
          :alt="sheet.name"
          @click="showSheet(sheet.id)"
        />
        <v-icon
          v-if="!sheet.avatar"
          dark
          :title="sheet.name"
          @click="showSheet(sheet.id)"
        >
          mdi-account-circle
        </v-icon>
      </v-list-item-avatar>
      <v-list-item-content>
        <v-list-item-title
          class="pointer"
          @click="showSheet(sheet.id)"
          v-text="sheet.name"
        />
      </v-list-item-content>
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
        sheets: (state) => state.game.sheets,
      }),
    },
    methods: {
      showSheet(id) {
        const key = Date.now()
        this.$store.commit(ADD_OPEN_MODAL, { name: 'sheet', key, id: id })
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
</style>
