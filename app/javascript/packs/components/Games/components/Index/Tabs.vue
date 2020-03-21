<template>
  <v-tabs centered>
    <v-tab>
      Актуальные
    </v-tab>
    <v-tab>
      Завершенные
    </v-tab>

    <v-tab-item>
      <games-list :games="open" />
    </v-tab-item>
    <v-tab-item>
      <games-list :games="close" />
    </v-tab-item>
  </v-tabs>
</template>

<script>
  import { mapState } from 'vuex'

  import GamesList from './GamesList'

  export default {
    name: 'Tabs',
    components: { GamesList },
    computed: {
      ...mapState({
        open: state => state.games.open,
        close: state => state.games.close,
      }),
    },
  }
</script>
