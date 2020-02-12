import { handling } from '../../../../../helpers/errorsHandling'
import { deleteGame, loadGames } from '../../api'

export default {
  async loadAdminGames({ commit }) {
    try {
      commit('GAMES_ADMIN_LOADED', await loadGames())
    } catch (error) {
      handling(commit, error)
    }
  },

  async deleteGame({ commit }, id) {
    try {
      await deleteGame(id)
      commit('DELETE_GAME', id)
    } catch (error) {
      handling(commit, error)
    }
  },
}
