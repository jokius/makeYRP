import { handling } from '../../../../helpers/errorsHandling'
import {
  createFolder,
  createMenuItem,
  deleteFolder,
  deleteImage,
  deleteMenuItem,
  loadFolder,
  loadGame,
  loadMessages,
  loadSheets,
  updateFolder,
  updateImage,
  updateMenuItem,
} from '../../api'
import {
  DELETE_FOLDER,
  DELETE_IMAGE,
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
}
