import actions from './actions'
import mutations from './mutations'

export default {
  state() {
    return {
      isValid: false,
      email: '',
      nickname: '',
      password: '',
      errors: {},
    }
  },

  actions,
  mutations,
}
