import actions from './actions'
import mutations from './mutations'

export default {
  state() {
    return {
      loaded: false,
      list: [],
      errors: [],
    }
  },

  actions,
  mutations,
}
