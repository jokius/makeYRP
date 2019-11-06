import actions from './actions'
import mutations from './mutations'

export default {
  state() {
    return {
      info: {},
      loaded: false,
    }
  },

  actions,
  mutations,
}
