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
  UPDATE_SHEET_PARAMS,
  UPDATE_SHEETS,
  UPDATE_SHEET_NAME,
  ADD_MENU_ITEM,
  UPDATE_MENU_ITEM,
  DELETE_MENU_ITEM,
  CHANGE_CURRENT_LAYER,
  CHANGE_CURRENT_CURSOR,
  CHANGE_BORDER_SIZE,
  CHANGE_BORDER_COLOR,
  CHANGE_BODY_COLOR,
  USER_LOADED,
  ACCESS_SHEET,
  ADD_MARKER,
  RESET_MARKER,
  ADD_CURRENT_ITEM,
} from '../mutation-types'
import { GameModel } from '../../../../models/GameModel'
import { SheetModel } from '../../../../models/SheetModel'
import { FolderModel } from '../../../../models/FolderModel'
import { MessageModel } from '../../../../models/MessageModel'
import { UserModel } from '../../../../models/UserModel'

const addSheet = (state, raw) => {
  const sheet = new SheetModel().setInfo(raw)
  sheet.acl.currentUserId = state.currentUser.id
  sheet.acl.masterId = state.info.master.id
  if (!sheet.acl.canRead) return

  state.sheets = [...state.sheets, sheet]
}

const deleteSheet = (state, id) => state.sheets = state.sheets.filter(sheet => sheet.id !== id)

export default {
  [SET_LOADED](state) {
    state.loaded = true
  },

  [GAME_LOADED](state, game) {
    state.info = new GameModel().setInfo(game)
  },

  [USER_LOADED](state, user) {
    state.currentUser = new UserModel().setInfo(user)
  },

  [ADD_OPEN_MODAL](state, params) {
    state.openModals = [...state.openModals, params]
  },

  [REMOVE_OPEN_MODAL](state, key) {
    state.openModals = state.openModals.filter(modal => modal.key !== key)
  },

  [UPDATE_CURRENT_PAGE](state, index) {
    state.currentPage = state.info.getPage(index)
  },

  [ADD_PAGE](state, page) {
    state.info = state.info.addPage(page)
  },

  [DELETE_PAGE](state, id) {
    state.info = state.info.deletePage(id)
    const maxIndex = state.info.pages.length - 1
    if (maxIndex > state.currentPage) state.currentPage = maxIndex
  },

  [UPDATE_PAGE_NAME](state, name) {
    state.pageName = name
  },

  [ADD_SHEET](state, raw) {
    addSheet(state, raw)
    if (state.currentItem.mark !== 'sheet') state.marks = { ...state.marks, sheet: state.marks.sheet + 1 }
  },

  [SHEETS_LOADED](state, sheets) {
    state.sheets = []
    sheets.map(sheet => addSheet(state, sheet))
  },

  [ACCESS_SHEET](state, raw) {
    let index = state.sheets.findIndex(item => item.id === raw.id)
    let sheet = state.sheets[index]

    if (sheet) {
      sheet.setInfo(raw)
    } else {
      sheet = new SheetModel().setInfo(raw)
    }

    sheet.acl.currentUserId = state.currentUser.id
    sheet.acl.masterId = state.info.master.id

    if (sheet.acl.canRead) {
      if (index >= 0) state.sheets[index] = sheet
      else state.sheets = [...state.sheets, sheet]
    } else {
      if (index >= 0) deleteSheet(state, sheet.id)
    }
  },

  [DELETE_SHEET](state, id) {
    deleteSheet(state, id)
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
    switch (obj.type) {
      case 'page':
        state.info = state.info.changePageBackgroundColor(obj)
        break
      case 'grid':
        state.info = state.info.changePageGridColor(obj)
        break
      default:
        break
    }
  },

  [MESSAGES_LOADED](state, messages) {
    state.messages = messages.map(message => (
      new MessageModel().setInfo(message)
    ))
  },

  [ADD_MESSAGE](state, message) {
    state.messages.push(new MessageModel().setInfo(message))
    if (state.currentItem.mark !== 'chat') state.marks = { ...state.marks, chat: state.marks.chat + 1 }
  },

  [UPDATE_SHEET](state, raw) {
    const sheet = state.sheets.find(item => item.id === raw.id)
    sheet.setInfo(raw)
  },

  [UPDATE_SHEETS](state, sheet) {
    const index = state.sheets.findIndex(item => item.id === sheet.id)
    state.sheets[index] = state.sheets[index].setInfo(sheet)
  },

  [UPDATE_SHEET_NAME](state, { id, name }) {
    const index = state.sheets.findIndex(item => item.id === id)
    state.sheets[index].name = name
  },

  [UPDATE_SHEET_PARAMS](state, { id, path, value, remove = false }) {
    const index = state.sheets.findIndex(item => item.id === id)
    let mutVal = value
    if (remove) {
      mutVal = get(state.sheets[index].params, path, []).slice()
      mutVal.splice(value, 1)
    }
    set(state.sheets[index].params, path, mutVal)
  },

  [ADD_MENU_ITEM](state, raw) {
    const menu = state.info.menus.find(item => item.id === raw.menu_id)
    menu.addItem(raw)
    const mark = menu.params.mark
    if (!mark) return

    if (state.currentItem.mark !== mark) state.marks = { ...state.marks, [mark]: state.marks[mark] + 1 }
  },

  [UPDATE_MENU_ITEM](state, raw) {
    const menu = state.info.menus.find(item => item.id === raw.menu_id)
    const item = menu.items.find(item => item.id === raw.id)
    item.setInfo(raw)
  },

  [DELETE_MENU_ITEM](state, raw) {
    const menu = state.info.menus.find(item => item.id === raw.menu_id)
    menu.items = menu.items.filter(item => item.id !== raw.id)
  },

  [CHANGE_CURRENT_CURSOR](state, value) {
    state.currentCursor = value
  },

  [CHANGE_CURRENT_LAYER](state, value) {
    state.currentLayer = value
  },

  [CHANGE_BORDER_SIZE](state, value) {
    state.borderSize = value
  },

  [CHANGE_BORDER_COLOR](state, value) {
    state.borderColor = value
  },

  [CHANGE_BODY_COLOR](state, value) {
    state.bodyColor = value
  },

  [ADD_MARKER](state, mark) {
    state.marks = { ...state.marks, [mark]: 0 }
  },

  [RESET_MARKER](state, mark) {
    state.marks = { ...state.marks, [mark]: 0 }
  },

  [ADD_CURRENT_ITEM](state, value) {
    state.currentItem = value
  },
}
