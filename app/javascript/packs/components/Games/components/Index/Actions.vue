<template>
  <div class="text-center">
    <v-btn
      class="ma-2"
      tile
      color="indigo"
      dark
      :href="createGame"
    >
      Создать игру
    </v-btn>
    <v-btn
      v-if="admin"
      class="ma-2"
      tile
      color="indigo"
      dark
      :href="newSystem"
    >
      Добавить систему
    </v-btn>
  </div>
</template>

<script>
  import { mapState } from 'vuex'

  import links from '../../../../helpers/links'

  export default {
    name: 'Actions',
    data: () => ({
      newSystem: links.base.newSystem,
      createGame: links.base.createGame,
    }),

    computed: {
      ...mapState({
        currentUser: state => state.currentUser.info,
      }),

      admin() {
        return this.currentUser.admin
      },
    },
  }
</script>
