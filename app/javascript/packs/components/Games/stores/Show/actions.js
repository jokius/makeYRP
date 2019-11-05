import { handling } from '../../../../helpers/errorsHandling'
import {
  createPage,
  createSheet,
  deletePage,
  deleteSheet,
  loadGame,
  loadSheets,
} from '../../api'
import {
  ADD_PAGE,
  ADD_SHEET,
  DELETE_PAGE,
  DELETE_SHEET,
  GAME_LOADED,
  SET_LOADED,
  SHEETS_LOADED,
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
}
