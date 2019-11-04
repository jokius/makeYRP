import actions from './actions'
import mutations from './mutations'

export default {
  state: {
    loaded: false,
    info: null,
    characters: [],
    openModals: [],
    leftMenus: [],
    currentMenu: 0,
    currentPage: null,
    pageName: null,
  },

  actions,
  mutations,
}
