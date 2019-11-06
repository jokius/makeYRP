import { handling } from '../../../../helpers/errorsHandling'
import { addSystem } from '../../api'

export default {
  async addSystem({ commit }, params) {
    try {
      await addSystem(params)
    } catch (error) {
      handling(commit, error)
    }
  },
}
