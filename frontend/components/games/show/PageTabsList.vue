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

  export default {
    name: 'PageTabsList',

    data() {
      return {
        currentPageIndex: 0,
      }
    },

    computed: {
      ...mapState({
        game: state => state.game.info,
      }),

      pages() {
        return this.game.pages
      },

      current: {
        get() {
          return this.currentPageIndex
        },

        set(index) {
          this.$store.commit('game/updateCurrentPage', index)
        },
      },
    },

    methods: {
      deletePage(id) {
        this.$cable.perform({
          channel: 'GameChannel',
          action: 'remove',
          data: { id, type: 'page' },
        })
      },
    },
  }
</script>

<style scoped lang="scss">
  @import '~assets/css/colors';

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
