<template>
  <v-simple-table>
    <template v-slot:default>
      <thead>
        <tr>
          <th class="text-left">id</th>
          <th class="text-left">Название</th>
          <th class="text-left">Мастер</th>
          <th class="text-left">Система</th>
          <th class="text-left" />
        </tr>
      </thead>
      <tbody>
        <tr v-for="game in games" :key="game.id">
          <td>{{ game.id }}</td>
          <td>{{ game.name }}</td>
          <td>{{ game.master.nickname }}</td>
          <td>{{ game.system }}</td>
          <td>
            <v-btn
              color="red darken-4"
              fab
              x-small
              dark
              @click="deleteGame(game.id)"
            >
              <v-icon>mdi-delete</v-icon>
            </v-btn>
          </td>
        </tr>
      </tbody>
    </template>
  </v-simple-table>
</template>

<script>

  export default {
    name: 'GamesList',
    props: { games: { type: Array, required: true } },
    methods: {
      deleteGame(id) {
        this.$store.dispatch('deleteGame', id)
      },
    },
  }
</script>
