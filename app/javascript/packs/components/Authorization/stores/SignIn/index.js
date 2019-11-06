import actions from './actions'
import mutations from './mutations'

export default {
  state() {
    return {
      isValid: false,
      email: '',
      password: '',
      errors: {},
    }
  },

  actions,
  mutations,
}
