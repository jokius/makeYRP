import actions from './actions'
import mutations from './mutations'

export default {
  state() {
    return {
      list: null,
      loaded: null,
    }
  },

  actions,
  mutations,
}