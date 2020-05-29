import { handling } from '../../lib/errorsHandling'
import { deleteGame, loadGames } from '../../api/admin/games'
import { GameModel } from '../../models/GameModel'

export const state = () => ({
  list: [],
  errors: [],
  loaded: false,
})

export const actions = {
  async load({ commit }, axios) {
    try {
      commit('loaded', await loadGames(axios))
    } catch (error) {
      handling(error)
    }
  },

  async remove({ commit }, { axios, id }) {
    try {
      await deleteGame({ axios, id })
      commit('remove', id)
    } catch (error) {
      handling(error)
    }
  }
}

export const mutations = {
  loaded(state, games) {
    state.list = games.map(game => new GameModel().setInfo(game))
    state.loaded = true
  },

  remove(state, id) {
    state.list = state.list.filter(item => item.id !== id)
  },
}
