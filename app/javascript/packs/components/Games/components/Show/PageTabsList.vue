<template>
  <v-chip-group
    v-model="current"
    mandatory
    active-class="indigo--text"
  >
    <v-chip
      v-for="page in pages"
      :key="page.id"
      close
      @click:close="deletePage(page.id)"
    >
      {{ page.name }}
    </v-chip>
  </v-chip-group>
</template>

<script>
  import { mapState } from 'vuex'

  import { UPDATE_CURRENT_PAGE } from '../../stores/mutation-types'

  export default {
    name: 'PageTabsList',
    computed: {
      ...mapState({
        game: (state) => state.game.info,
        currentPage: (state) => state.game.currentPage,
      }),

      pages() {
        return this.game.pages
      },

      current: {
        get() {
          return this.currentPage
        },

        set(index) {
          this.$store.commit(UPDATE_CURRENT_PAGE, index)
        },
      },
    },
    methods: {
      deletePage(id) {
        this.$store.dispatch('deletePage', id)
      },
    },
  }
</script>

<style scoped lang="scss">
  @import 'app/javascript/packs/components/ui/css/colors';

  .main {
    background-color: $gray52;
  }

  .select {
    background-color: $purple51;
  }

  .buttonGroup {
    height: 55px;
    margin-right: 2px;
  }
</style>
