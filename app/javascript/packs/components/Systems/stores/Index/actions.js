import { handling } from '../../../../helpers/errorsHandling'
import { loadSystems } from '../../api'
import { UPDATE_SYSTEMS } from '../mutation-types'

export default {
  async loadSystems({ commit }) {
    try {
      commit(UPDATE_SYSTEMS, await loadSystems())
    } catch (error) {
      handling(commit, error)
    }
  },
}
