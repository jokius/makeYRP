import { handling } from '../../../../helpers/errorsHandling'
import { signUpReq } from '../../api'

export default {
  async signUp({ commit }, user) {
    try {
      await signUpReq(user)
    } catch (error) {
      handling(commit, error)
    }
  },
}
