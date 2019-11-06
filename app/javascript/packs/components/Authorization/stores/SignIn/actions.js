import { handling } from '../../../../helpers/errorsHandling'
import { signInReq } from '../../api'

export default {
  async signIn({ commit }, user) {
    try {
      await signInReq(user)
    } catch (error) {
      handling(commit, error)
    }
  },
}
