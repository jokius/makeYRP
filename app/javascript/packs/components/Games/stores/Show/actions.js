import { defaultsDeep } from 'lodash'

import { handling } from '../../../../helpers/errorsHandling'
import {
  createFolder,
  createMenuItem,
  createMessage,
  createPage,
  createSheet, createToken,
  deleteFolder,
  deleteImage,
  deleteMenuItem,
  deletePage,
  deleteSheet,
  loadFolder,
  loadGame,
  loadMessages,
  loadSheets,
  updateFolder,
  updateImage,
  updateMenuItem,
  updatePage,
  updateSheet,
} from '../../api'
import {
  DELETE_FOLDER,
  DELETE_IMAGE,
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
} from '../mutation-types'

const sendPageParams = async (state, payload) => {
  const game = state.info
  const page = state.currentPage
  const params = defaultsDeep(payload, page.params)
  const ids = { game_id: game.id, id: page.id }

  return await updatePage(ids, { name: page.name, page_params: params })
}

const sendSheetParams = async ({ gameId, sheet, changes }) => {
  const result = defaultsDeep(changes, sheet)
  return await updateSheet({ game_id: gameId, ...result })
}

export default {
  async loadGame({ commit }, id) {
    try {
      commit(GAME_LOADED, await loadGame(id))
      commit(SHEETS_LOADED, await loadSheets(id))
      commit(MESSAGES_LOADED, await loadMessages(id))
      commit(UPDATE_CURRENT_PAGE, 0)
      commit(SET_LOADED)
    } catch (error) {
      handling(commit, error)
    }
  },

  async createPage({ commit, state }, name) {
    try {
      const game = state.info
      await createPage(game.id,{ name: name })
    } catch (error) {
      handling(commit, error)
    }
  },

  async deletePage({ commit, state }, id) {
    try {
      const game = state.info
      await deletePage({ game_id: game.id, id })
    } catch (error) {
      handling(commit, error)
    }
  },

  async createSheet({ commit, state }, sheet_type) {
    try {
      const game = state.info
      await createSheet(game.id,{ sheet_type })
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
      await sendPageParams(state, params)
    } catch (error) {
      handling(commit, error)
    }
  },

  async changeSheet({ commit, state }, payload) {
    try {
      await sendSheetParams({ ...payload, gameId: state.info.id })
    } catch (error) {
      handling(commit, error)
    }
  },

  async saveSheet({ commit, state }, sheet) {
    try {
      await updateSheet({ game_id: state.info.id, ...sheet })
    } catch (error) {
      handling(commit, error)
    }
  },

  async saveTargetColor({ commit, state }, obj) {
    try {
      switch (obj.type) {
        case 'page':
          await sendPageParams(state, { background: { color: obj.color } })
          break
        case 'grid':
          await sendPageParams(state, { grid: { color: obj.color } })
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

  async createMenuItem({ commit, state }, params) {
    try {
      const game = state.info
      await createMenuItem(game.id, params)
    } catch (error) {
      handling(commit, error)
    }
  },

  async updateMenuItem({ commit }, { id, params }) {
    try {
      await updateMenuItem(id, params)
    } catch (error) {
      handling(commit, error)
    }
  },

  async deleteMenuItem({ commit }, id) {
    try {
      await deleteMenuItem(id)
    } catch (error) {
      handling(commit, error)
    }
  },

  async createToken({ commit, state }, params) {
    try {
      const page = state.currentPage
      if (!page) return
      await createToken(page.id, params)
    } catch (error) {
      handling(commit, error)
    }
  },
}
