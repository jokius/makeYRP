import actions from './actions'
import mutations from './mutations'

export default {
  state() {
    return {
      loaded: false,
      info: null,
      sheets: [],
      openModals: [],
      leftMenus: [],
      currentMenu: 0,
      currentPage: {},
      pageName: null,
      foldersLoaded: false,
      folder: {},
      currentRightClickMenu: '',
    }
  },

actions,
  mutations,
}
