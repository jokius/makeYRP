import Vue from 'vue'
import Vuex from 'vuex'

import games from '../components/Games/stores/Index'
import newGame from '../components/Games/stores/New'
import game from '../components/Games/stores/Show'
import currentUser from '../components/CurrentUser/stores/Show'
import newSystem from '../components/Systems/stores/New'
import systems from '../components/Systems/stores/Index'
import adminGames from '../components/admin/Games/stores/Index'

Vue.use(Vuex)

export default new Vuex.Store({
  strict: process.env.NODE_ENV !== 'production',
  modules: {
    games,
    newGame,
    game,
    currentUser,
    newSystem,
    systems,
    adminGames,
  },
})
