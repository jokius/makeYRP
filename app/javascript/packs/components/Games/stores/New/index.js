import actions from './actions'
import mutations from './mutations'

export default {
  state() {
    return {
      id: null,
      system_id: null,
      name: null,
    }
  },

  actions,
  mutations,
}
