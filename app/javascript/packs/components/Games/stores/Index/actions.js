import { handling } from '../../../../helpers/errorsHandling'
import { loadGames } from '../../api'

export default {
  async loadGames({ commit }) {
    try {
      const open = await loadGames({ open: true })
      const close = await loadGames({ open: false })
      commit('GAMES_LOADED', { open, close })
    } catch (error) {
      handling(commit, error)
    }
  },
}
