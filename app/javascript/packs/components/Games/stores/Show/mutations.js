import {
  ADD_OPEN_MODAL,
  GAME_LOADED,
  REMOVE_OPEN_MODAL,
  UPDATE_CURRENT_MENU,
  UPDATE_LEFT_MENU,
  UPDATE_CURRENT_PAGE,
  ADD_PAGE,
  DELETE_PAGE,
  UPDATE_PAGE_NAME,
} from '../mutation-types'
import { GameModel } from '../../../../models/GameModel'

export default {
  [GAME_LOADED](state, game) {
    state.info = new GameModel().setInfo(game)
    state.loaded = true
  },

  [ADD_OPEN_MODAL](state, params) {
    state.openModals = [...state.openModals, params]
  },

  [REMOVE_OPEN_MODAL](state, key) {
    state.openModals = state.openModals.filter((modal) => modal.key !== key)
  },

  [UPDATE_LEFT_MENU](state, list) {
    state.leftMenus = list
  },

  [UPDATE_CURRENT_MENU](state, index) {
    state.currentMenu = state.currentMenu !== index ? index : -1
  },

  [UPDATE_CURRENT_PAGE](state, index) {
    state.currentPage = index
  },

  [ADD_PAGE](state, page) {
    state.info = new GameModel().addPage(page)
    state.currentPage = state.info.pages.length - 1
  },

  [DELETE_PAGE](state, index) {
    state.info = new GameModel().deletePage(index)
    if (state.currentPage === index) state.currentPage -= 1
  },

  [UPDATE_PAGE_NAME](state, name) {
    state.pageName = name
  },
}
