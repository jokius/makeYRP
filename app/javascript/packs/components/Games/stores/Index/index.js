import actions from './actions'
import mutations from './mutations'

export default {
  state: {
    loaded: false,
    open: [],
    close: [],
    errors: [],
  },

  actions,
  mutations,
}
