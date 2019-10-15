import { signUpReq } from '../api'
import { handling } from '../../../../helpers/errorsHandling'

export default {
  async signUp({ commit }, user) {
    try {
      await signUpReq(user)
    } catch (error) {
      handling(commit, error)
    }
  },
}
