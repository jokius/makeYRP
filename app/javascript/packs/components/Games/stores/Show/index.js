import actions from './actions'
import mutations from './mutations'

export default {
  state() {
    return {
      loaded: false,
      info: null,
      sheets: [],
      openModals: [],
      currentPage: {},
      pageName: null,
      foldersLoaded: false,
      folder: {},
      currentRightClickMenu: '',
      messages: [],
    }
  },

actions,
  mutations,
}
