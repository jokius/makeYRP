import { handling } from '../lib/errorsHandling'
import { createGame, loadGames } from '../api/games'
import { GameModel } from '../models/GameModel'

export const state = () => ({
  open: [],
  close: [],
  errors: [],
  loaded: false,
  id: null
})

export const actions = {
  async load({ commit }, axios) {
    try {
      const open = await loadGames({ axios, params: { open: true } })
      const close = await loadGames({ axios, params: { open: false } })
      commit('gamesLoaded', { open, close })
    } catch (error) {
      handling(error)
    }
  },

  async create({ commit }, params) {
    try {
      const result = await createGame(params)
      commit('updateGameId', result.id)
    } catch (error) {
      handling(commit, error)
    }
  }
}

export const mutations = {
  gamesLoaded(state, games) {
    state.open = games.open.map(game => new GameModel().setInfo(game))
    state.close = games.close.map(game => new GameModel().setInfo(game))
    state.loaded = true
  },

  updateGameId(state, id) {
    state.id = id
  },
}
