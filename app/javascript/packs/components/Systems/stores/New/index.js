import actions from './actions'
import mutations from './mutations'

export default {
  state() {
    return {
      name: null,
      text: null,
      files: null,
    }
  },

  actions,
  mutations,
}
