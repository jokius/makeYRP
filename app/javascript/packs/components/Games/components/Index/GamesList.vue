<template>
  <v-list three-line>
    <template v-for="game in games">
      <v-list-item
        :key="game.id"
        :to="openGame(game.id)"
      >
        <v-list-item-content>
          <v-list-item-title v-html="game.name" />
          <v-list-item-subtitle>
            <span>Мастер: </span>
            <v-avatar size="24" color="indigo">
              <img
                v-if="game.master.avatar.thumb"
                :src="game.master.avatar.thumb"
                :alt="game.master.nickname"
              />
              <v-icon
                v-if="!game.master.avatar.thumb"
                dark
                :title="game.master.nickname"
              >
                mdi-account-circle
              </v-icon>
            </v-avatar>
          </v-list-item-subtitle>
          <v-list-item-subtitle>
            <span>Игроки: </span>
            <span v-if="game.users.length === 0">Нет</span>
            <template v-for="user in game.users">
              <v-avatar :key="user.id" size="24" color="indigo">
                <img
                  v-if="user.avatar.thumb"
                  :src="user.avatar.thumb"
                  :alt="user.nickname"
                />
                <v-icon v-if="!user.avatar.thumb" dark>mdi-account-circle</v-icon>
              </v-avatar>
            </template>
          </v-list-item-subtitle>
          <v-divider />
        </v-list-item-content>
      </v-list-item>
    </template>
  </v-list>
</template>

<script>
  import links from '../../../../helpers/links'

  export default {
    name: 'GamesList',
    props: { games: { type: Array, required: true } },
    methods: {
      openGame(id) {
        return links.dynamic(links.base.game, { id })
      },
    },
  }
</script>
