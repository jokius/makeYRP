<template>
  <div class="text-center">
    <v-btn
      tile
      color="indigo"
      dark
      :href="createGame"
    >
      Создать игру
    </v-btn>
    <v-btn
      v-if="user.admin"
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
  import links from '../../lib/links'

  export default {
    name: 'Actions',
    data: () => ({
      newSystem: links.base.newSystem,
      createGame: links.base.createGame,
    }),

    computed: {
      ...mapState({
        user: state => state.auth.user,
      }),
    },
  }
</script>
