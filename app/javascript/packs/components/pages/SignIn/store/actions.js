import { signInReq } from '../api'
import { handling } from '../../../../helpers/errorsHandling'

export default {
  async signIn({ commit }, user) {
    try {
      await signInReq(user)
    } catch (error) {
      handling(commit, error)
    }
  },
}
