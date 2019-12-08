import { defaultsDeep } from 'lodash'

import { handling } from '../../../../helpers/errorsHandling'
import {
  createFolder,
  createMessage,
  createPage,
  createSheet,
  deleteFolder,
  deleteImage,
  deletePage,
  deleteSheet,
  loadFolder,
  loadGame,
  loadMessages,
  loadSheets,
  updateFolder,
  updateImage,
  updatePage,
  updateSheet,
} from '../../api'
import {
  ADD_OPEN_MODAL,
  ADD_PAGE,
  ADD_SHEET,
  DELETE_FOLDER,
  DELETE_IMAGE,
  DELETE_PAGE,
  DELETE_SHEET,
  FOLDERS_LOADED,
  FOLDERS_UNLOADED,
  GAME_LOADED,
  MESSAGES_LOADED,
  SET_LOADED,
  SHEETS_LOADED,
  UPDATE_CURRENT_PAGE,
  UPDATE_CURRENT_RIGHT_CLICK_MENU,
  UPDATE_FOLDER,
  UPDATE_IMAGE,
  UPDATE_PAGE,
  UPDATE_SHEET,
} from '../mutation-types'

const sendPageParams = async (state, payload) => {
  const page = state.currentPage
  const params = defaultsDeep(payload, page.params)
  const ids = { game_id: 0, id: page.id }

  return await updatePage(ids, { name: page.name, page_params: params })
}

const sendSheetParams = async ({ sheet, changes }) => {
  const result = defaultsDeep(changes, sheet)
  return await updateSheet({ game_id: 0, ...result })
}

const removeMe = (commit, sheet) => {
  const key = Date.now()
  commit(ADD_OPEN_MODAL, { name: 'sheet', key, id: sheet.id, sheetType: sheet.sheet_type })
}

export default {
  async loadGame({ commit }, id) {
    try {
      commit(GAME_LOADED, await loadGame(id))
      const sheets = await loadSheets(id) // remove me
      commit(SHEETS_LOADED, sheets) // rollback me
      commit(MESSAGES_LOADED, await loadMessages(id))
      commit(UPDATE_CURRENT_PAGE, 0)
      commit(SET_LOADED)
      removeMe(commit, sheets[0])
    } catch (error) {
      handling(commit, error)
    }
  },

  async createPage({ commit, state }, name) {
    try {
      const game = state.info
      commit(ADD_PAGE, await createPage(game.id,{ name: name }))
    } catch (error) {
      handling(commit, error)
    }
  },

  async deletePage({ commit }, id) {
    try {
      await deletePage({ game_id: 0, id })
      commit(DELETE_PAGE, id)
    } catch (error) {
      handling(commit, error)
    }
  },

  async createSheet({ commit, state }, sheet_type) {
    try {
      const game = state.info
      commit(ADD_SHEET, await createSheet(game.id,{ sheet_type }))
    } catch (error) {
      handling(commit, error)
    }
  },

  async deleteSheet({ commit, state }, id) {
    try {
      const game = state.info
      await deleteSheet(game.id, id)
      commit(DELETE_SHEET, id)
    } catch (error) {
      handling(commit, error)
    }
  },

  async loadFolder({ commit }, params) {
    try {
      commit(FOLDERS_UNLOADED)
      commit(FOLDERS_LOADED, await loadFolder(params))
    } catch (error) {
      handling(commit, error)
    }
  },

  async createFolder({ commit }, params) {
    try {
      commit(FOLDERS_UNLOADED)
      commit(FOLDERS_LOADED, await createFolder(params))
    } catch (error) {
      handling(commit, error)
    }
  },

  async renameObj({ commit }, obj) {
    commit(UPDATE_CURRENT_RIGHT_CLICK_MENU, '')
    switch (obj.type) {
      case 'folder':
        commit(UPDATE_FOLDER, await updateFolder(obj))
        break
      case 'image':
        commit(UPDATE_IMAGE, await updateImage(obj))
        break
      default:
        break
    }
  },

  async removeObj({ commit }, obj) {
    commit(UPDATE_CURRENT_RIGHT_CLICK_MENU, '')
    const id = obj.id
    switch (obj.type) {
      case 'folder':
        await deleteFolder(id)
        commit(DELETE_FOLDER, id)
        break
      case 'image':
        await deleteImage(id)
        commit(DELETE_IMAGE, id)
        break
      default:
        break
    }
  },

  async changePage({ commit, state }, params) {
    try {
      commit(UPDATE_PAGE, await sendPageParams(state, params))
    } catch (error) {
      handling(commit, error)
    }
  },

  async changeSheet({ commit }, payload) {
    try {
      commit(UPDATE_SHEET, await sendSheetParams(payload))
    } catch (error) {
      handling(commit, error)
    }
  },

  async saveSheet({ commit }, sheet) {
    try {
      commit(UPDATE_SHEET, await updateSheet({ game_id: 0, ...sheet }))
    } catch (error) {
      handling(commit, error)
    }
  },

  async saveTargetColor({ commit, state }, obj) {
    try {
      switch (obj.target) {
        case 'pageBackground':
          commit(UPDATE_PAGE, await sendPageParams(state,
            { background: { color: obj.color } }
          ))
          break
        default:
          break
      }
    } catch (error) {
      handling(commit, error)
    }
  },

  async sendMessage({ commit, state }, body) {
    try {
      const game = state.info
      await createMessage(game.id,{ body })
    } catch (error) {
      handling(commit, error)
    }
  },
}
