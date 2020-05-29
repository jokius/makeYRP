<template>
  <v-list three-line>
    <template v-for="game in games">
      <v-list-item :key="game.id" class="border-bottom">
        <v-list-item-content>
          <div class="title-grid">
            <v-list-item-title v-html="game.name" />
            <v-btn color="success" max-width="150" @click="openGame(game.id)">Загрузить</v-btn>
          </div>
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
        </v-list-item-content>
      </v-list-item>
    </template>
  </v-list>
</template>

<script>

  import { joinGame } from '../../api/games'
  import links from '../../lib/links'

  export default {
    name: 'GamesList',
    props: { games: { type: Array, required: true } },
    methods: {
      openGame(id) {
        joinGame({ axios: this.$axios, id }).then(() =>
          this.$router.push(links.dynamic(links.base.game, { id }))
        )
      },
    },
  }
</script>

<style scoped lang="scss">
  @import '~assets/css/colors';

  .title-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
  }

  .border-bottom {
    border-bottom: 1px solid $black;
  }
</style>
