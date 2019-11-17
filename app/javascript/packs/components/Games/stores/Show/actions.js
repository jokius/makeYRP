import { handling } from '../../../../helpers/errorsHandling'
import {
  createFolder,
  createPage,
  createSheet,
  deleteFolder,
  deleteImage,
  deletePage,
  deleteSheet,
  loadFolder,
  loadGame,
  loadSheets,
  updateFolder,
  updateImage,
} from '../../api'
import {
  ADD_PAGE,
  ADD_SHEET,
  DELETE_FOLDER,
  DELETE_IMAGE,
  DELETE_PAGE,
  DELETE_SHEET,
  FOLDERS_LOADED,
  FOLDERS_UNLOADED,
  GAME_LOADED,
  SET_LOADED,
  SHEETS_LOADED,
  UPDATE_CURRENT_RIGHT_CLICK_MENU,
  UPDATE_FOLDER,
  UPDATE_IMAGE,
} from '../mutation-types'

export default {
  async loadGame({ commit }, id) {
    try {
      const game = await loadGame(id)
      commit(SHEETS_LOADED, await loadSheets(id))
      commit(GAME_LOADED, game)
      commit(SET_LOADED)
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

  async deletePage({ commit, state }, id) {
    try {
      const game = state.info
      await deletePage({ game_id: game.id, id })
      commit(DELETE_PAGE, id)
    } catch (error) {
      handling(commit, error)
    }
  },

  async createSheet({ commit, state }, type) {
    try {
      const game = state.info
      commit(ADD_SHEET, await createSheet(game.id,{ type }))
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
}
