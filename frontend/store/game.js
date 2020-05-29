import { get, set } from 'lodash'
import { FolderModel } from '../models/FolderModel'
import { createFolder, deleteFolder, deleteImage, loadFolder, updateFolder, updateImage } from '../api/folder'
import { handling } from '../lib/errorsHandling'
import { GameModel } from '../models/GameModel'
import { loadGame, loadMessages, loadSheets } from '../api/game'
import { SheetModel } from '../models/SheetModel'
import { MessageModel } from '../models/MessageModel'

export const state = () => ({
  info: null,
  currentCursor: 'default',
  currentLayer: 'players',
  openModals: [],
  currentPage: {},
  currentItem: {},
  marks: {},
  sheets: [],
  folder: {},
  foldersLoaded: false,
  loaded: false,
  currentUser: {},
  pageName: null,
  currentRightClickMenu: '',
  messages: [],
  borderSize: 3,
  borderColor: { r: 0, g: 0, b: 0, a: 1 },
  bodyColor: { r: 0, g: 0, b: 0, a: 0 },
  pageColor: {},
  specialTabs: [],
})

export const actions = {
  async load({ commit }, { axios, id, user }) {
    try {
      commit('gameLoaded', await loadGame({ axios, id }))
      const list = await loadSheets({ axios, id })
      commit('sheetsLoaded', { user, list })
      commit('messagesLoaded', await loadMessages({ axios, id }))
      commit('updateCurrentPage', 0)
      commit('setLoaded')
    } catch (error) {
      handling(error)
    }
  },

  async createFolder({ commit }, { axios, params }) {
    try {
      commit('foldersUnloaded')
      commit('foldersLoaded', await createFolder({ axios, params }))
    } catch (error) {
      handling(error)
    }
  },

  async loadFolder({ commit }, { axios, params }) {
    try {
      commit('foldersUnloaded')
      commit('foldersLoaded', await loadFolder({ axios, params }))
    } catch (error) {
      handling(error)
    }
  },

  async renameObj({ commit }, { axios, params }) {
    commit('updateCurrentRightClickMenu', '')
    switch (params.type) {
      case 'folder':
        commit('updateFolder', await updateFolder({ axios, params }))
        break
      case 'image':
        commit('updateImage', await updateImage({ axios, params }))
        break
      default:
        break
    }
  },

  async removeObj({ commit }, { axios, params }) {
    commit('updateCurrentRightClickMenu', '')
    const id = params.id
    switch (params.type) {
      case 'folder':
        await deleteFolder({ axios, id })
        commit('deleteFolder', id)
        break
      case 'image':
        await deleteImage({ axios, id })
        commit('deleteImage', id)
        break
      default:
        break
    }
  },
}

const addSheet = (state, { user, raw }) => {
  const sheet = new SheetModel().setInfo(raw)
  sheet.acl.currentUserId = user.id
  sheet.acl.masterId = state.info.master.id
  if (!sheet.acl.canRead) return

  state.sheets = [...state.sheets, sheet]
}

const deleteSheet = (state, id) => state.sheets = state.sheets.filter(sheet => sheet.id !== id)

export const mutations = {
  gameLoaded(state, game) {
    state.info = new GameModel().setInfo(game)
  },

  sheetsLoaded(state, { list, user }) {
    state.sheets = []
    list.map(raw => addSheet(state, { raw, user }))
  },

  changeCurrentCursor(state, value) {
    state.currentCursor = value
  },

  changeCurrentLayer(state, value) {
    state.currentLayer = value
  },

  changeBorderSize(state, value) {
    state.borderSize = value
  },

  addOpenModal(state, params) {
    state.openModals = [...state.openModals, params]
  },

  updateCurrentPage(state, index) {
    state.currentPage = state.info.getPage(index)
  },
  addCurrentItem(state, value) {
    state.currentItem = value
  },

  addMarker(state, mark) {
    state.marks = { ...state.marks, [mark]: 0 }
  },

  resetMarker(state, mark) {
    state.marks = { ...state.marks, [mark]: 0 }
  },

  updateSheetParams(state, { id, path, value, remove = false }) {
    const index = state.sheets.findIndex(item => item.id === id)
    let mutVal = value
    if (remove) {
      mutVal = get(state.sheets[index].params, path, []).slice()
      mutVal.splice(value, 1)
    }
    set(state.sheets[index].params, path, mutVal)
  },

  foldersLoaded(state, folder) {
    state.folder = new FolderModel().setInfo(folder)
    state.foldersLoaded = true
  },

  updateCurrentRightClickMenu(state, item) {
    state.currentRightClickMenu = item
  },

  foldersUnloaded(state) {
    state.foldersLoaded = false
  },

  updateFolder(state, obj) {
    state.folder = state.folder.updateChild(obj)
  },

  updateImage(state, obj) {
    state.folder = state.folder.updateImage(obj)
  },

  deleteFolder(state, id) {
    state.folder = state.folder.deleteChild(id)
  },

  deleteImage(state, id) {
    state.folder = state.folder.deleteImage(id)
  },

  updateSheetName(state, { id, name }) {
    const index = state.sheets.findIndex(item => item.id === id)
    state.sheets[index].name = name
  },

  updateMenuItemParams(state, { id, menuId, path, value }) {
    const menus = state.info.menus
    const menuIndex = menus.findIndex(item => item.id === menuId)
    const menu = menus[menuIndex]
    const item = menu.items.find(item => item.id === id)
    set(item.params, path, value)
  },

  removeOpenModal(state, key) {
    state.openModals = state.openModals.filter(modal => modal.key !== key)
  },

  updateSpecialTabs(state, specials) {
    state.specialTabs = specials.map((item, index) => {
      if (item && item.type === 'tab') return { index: index, tab: item }
    }).filter(Boolean)
  },

  changePageColor(state, { id, type, color }) {
    const colorObj = {}
    colorObj[id] = {}
    colorObj[id][type] = { color }
    state.pageColor = { ...state.pageColor, ...colorObj  }
  },

  changeBorderColor(state, value) {
    state.borderColor = value
  },

  changeBodyColor(state, value) {
    state.bodyColor = value
  },

  updatePageName(state, name) {
    state.pageName = name
  },

  deleteSheet(state, id) {
    deleteSheet(state, id)
  },

  updateSheet(state, raw) {
    const sheet = state.sheets.find(item => item.id === raw.id)
    sheet.setInfo(raw)
  },

  messagesLoaded(state, messages) {
    state.messages = messages.map(message => (
      new MessageModel().setInfo(message)
    ))
  },

  setLoaded(state) {
    state.loaded = true
  },

  addSheet(state, params) {
    addSheet(state, params)
    if (state.currentItem.mark !== 'sheet') state.marks = { ...state.marks, sheet: state.marks.sheet + 1 }
  },

  addPage(state, page) {
    state.info = state.info.addPage(page)
  },

  addMenuItem(state, raw) {
    const menu = state.info.menus.find(item => item.id === raw.menu_id)
    menu.addItem(raw)
    const mark = menu.params.mark
    if (!mark) return

    if (state.currentItem.mark !== mark) state.marks = { ...state.marks, [mark]: state.marks[mark] + 1 }
  },

  updateSheets(state, sheet) {
    const index = state.sheets.findIndex(item => item.id === sheet.id)
    state.sheets[index] = state.sheets[index].setInfo(sheet, false)
  },

  updatePage(state, page) {
    state.info = state.info.updatePage(page)
  },

  updateMenuItem(state, raw) {
    const menus = state.info.menus
    const menuIndex = menus.findIndex(item => item.id === raw.menu_id)
    const menu = menus[menuIndex]
    const item = menu.items.find(item => item.id === raw.id)
    item.setInfo(raw)
    state.info = { ...state.info, menus }
  },

  deletePage(state, id) {
    state.info = state.info.deletePage(id)
    const maxIndex = state.info.pages.length - 1
    if (maxIndex > state.currentPage) state.currentPage = maxIndex
  },

  deleteMenuItem(state, raw) {
    const menus = state.info.menus
    const menuIndex = menus.findIndex(item => item.id === raw.menu_id)
    const menu = menus[menuIndex]
    menu.items = menu.items.filter(item => item.id !== raw.id)
    state.info = { ...state.info, menus }
  },

  accessSheet(state, { user, raw }) {
    let index = state.sheets.findIndex(item => item.id === raw.id)
    let sheet = state.sheets[index]

    if (sheet) {
      sheet.setInfo(raw)
    } else {
      sheet = new SheetModel().setInfo(raw)
    }

    sheet.acl.currentUserId = user.id
    sheet.acl.masterId = state.info.master.id

    if (sheet.acl.canRead) {
      if (index >= 0) state.sheets[index] = sheet
      else state.sheets = [...state.sheets, sheet]
    } else {
      if (index >= 0) deleteSheet(state, sheet.id)
    }
  },

  addMessage(state, message) {
    state.messages.push(new MessageModel().setInfo(message))
    if (state.currentItem.mark !== 'chat') state.marks = { ...state.marks, chat: state.marks.chat + 1 }
  },
}
