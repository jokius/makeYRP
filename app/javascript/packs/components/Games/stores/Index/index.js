import actions from './actions'
import mutations from './mutations'

export default {
  state() {
    return {
      loaded: false,
      open: [],
      close: [],
      errors: [],
    }
  },

  actions,
  mutations,
}
