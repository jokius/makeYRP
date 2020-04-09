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
      currentUser: {},
      pageName: null,
      foldersLoaded: false,
      folder: {},
      currentRightClickMenu: '',
      messages: [],
      currentCursor: 'default',
      currentLayer: 'map', //change to players
      borderSize: 3,
      borderColor: { r: 0, g: 0, b: 0, a: 1 },
      bodyColor: { r: 0, g: 0, b: 0, a: 0 },
    }
  },

actions,
  mutations,
}
