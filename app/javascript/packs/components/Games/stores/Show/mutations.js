import { get, set } from 'lodash'

import {
  ADD_OPEN_MODAL,
  GAME_LOADED,
  REMOVE_OPEN_MODAL,
  UPDATE_CURRENT_PAGE,
  ADD_PAGE,
  DELETE_PAGE,
  UPDATE_PAGE_NAME,
  ADD_SHEET,
  SHEETS_LOADED,
  SET_LOADED,
  DELETE_SHEET,
  FOLDERS_UNLOADED,
  FOLDERS_LOADED,
  UPDATE_CURRENT_RIGHT_CLICK_MENU,
  DELETE_FOLDER,
  UPDATE_FOLDER,
  UPDATE_IMAGE,
  DELETE_IMAGE,
  UPDATE_PAGE,
  CHANGE_TARGET_COLOR,
  ADD_MESSAGE,
  MESSAGES_LOADED,
  UPDATE_SHEET,
  UPDATE_SHEET_NAME, UPDATE_SHEET_PARAMS,
} from '../mutation-types'
import { GameModel } from '../../../../models/GameModel'
import { SheetModel } from '../../../../models/SheetModel'
import { FolderModel } from '../../../../models/FolderModel'
import { MessageModel } from '../../../../models/MessageModel'

export default {
  [SET_LOADED](state) {
    state.loaded = true
  },

  [GAME_LOADED](state, game) {
    state.info = new GameModel().setInfo(game)
  },

  [ADD_OPEN_MODAL](state, params) {
    state.openModals = [...state.openModals, params]
  },

  [REMOVE_OPEN_MODAL](state, key) {
    state.openModals = state.openModals.filter((modal) => modal.key !== key)
  },

  [UPDATE_CURRENT_PAGE](state, index) {
    state.currentPage = state.info.getPage(index)
  },

  [ADD_PAGE](state, page) {
    state.info = state.info.addPage(page)
    state.currentPage = state.info.pages.length - 1
  },

  [DELETE_PAGE](state, id) {
    state.info = state.info.deletePage(id)
    const maxIndex = state.info.pages.length - 1
    if (maxIndex > state.currentPage) state.currentPage = maxIndex
  },

  [UPDATE_PAGE_NAME](state, name) {
    state.pageName = name
  },

  [SHEETS_LOADED](state, sheets) {
    state.sheets = sheets.map((sheet) => new SheetModel().setInfo(sheet))
  },

  [ADD_SHEET](state, sheet) {
    state.sheets = [...state.sheets, new SheetModel().setInfo(sheet)]
  },

  [DELETE_SHEET](state, id) {
    state.sheets = state.sheets.filter((sheet) => sheet.id !== id)
  },

  [FOLDERS_UNLOADED](state) {
    state.foldersLoaded = false
  },

  [FOLDERS_LOADED](state, folder) {
    state.folder = new FolderModel().setInfo(folder)
    state.foldersLoaded = true
  },

  [UPDATE_CURRENT_RIGHT_CLICK_MENU](state, item) {
    state.currentRightClickMenu = item
  },

  [UPDATE_FOLDER](state, obj) {
    state.folder = state.folder.updateChild(obj)
  },

  [DELETE_FOLDER](state, id) {
    state.folder = state.folder.deleteChild(id)
  },

  [UPDATE_IMAGE](state, obj) {
    state.folder = state.folder.updateImage(obj)
  },

  [DELETE_IMAGE](state, id) {
    state.folder = state.folder.deleteImage(id)
  },

  [UPDATE_PAGE](state, page) {
    state.info = state.info.updatePage(page)
  },

  [CHANGE_TARGET_COLOR](state, obj) {
    switch (obj.target) {
      case 'pageBackground':
        state.info = state.info.changePageBackgroundColor(obj)
        break
      default:
        break
    }
  },

  [MESSAGES_LOADED](state, messages) {
    state.messages = messages.map((message) => (
      new MessageModel().setInfo(message)
    ))
  },

  [ADD_MESSAGE](state, message) {
    state.messages.push(new MessageModel().setInfo(message))
  },

  [UPDATE_SHEET](state, raw) {
    const sheet = state.sheets.find((item) => item.id === raw.id)
    sheet.setInfo(raw)
  },

  [UPDATE_SHEET_NAME](state, { id, name }) {
    const index = state.sheets.findIndex((item) => item.id === id)
    state.sheets[index].name = name
  },

  [UPDATE_SHEET_PARAMS](state, { id, path, value, remove = false }) {
    const index = state.sheets.findIndex((item) => item.id === id)
    let mutVal = value
    if (remove) {
      mutVal = get(state.sheets[index].params, path, []).slice()
      mutVal.splice(value, 1)
    }
    set(state.sheets[index].params, path, mutVal)
  },
}
