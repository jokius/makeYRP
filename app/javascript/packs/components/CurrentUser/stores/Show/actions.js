import { loadCurrentUser } from '../../api'
import { handling } from '../../../../helpers/errorsHandling'

export default {
  async loadCurrentUser({ commit, full }) {
    try {
      commit('CURRENT_USER_LOADED', await loadCurrentUser({ full }))
    } catch (error) {
      handling(commit, error)
    }
  },
}
