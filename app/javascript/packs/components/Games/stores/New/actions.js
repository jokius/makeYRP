import { handling } from '../../../../helpers/errorsHandling'
import { createGame } from '../../api'
import { UPDATE_ID } from '../mutation-types'

export default {
  async createGame({ commit }, params) {
    try {
      const result = await createGame(params)
      commit(UPDATE_ID, result.id)
    } catch (error) {
      handling(commit, error)
    }
  },
}
