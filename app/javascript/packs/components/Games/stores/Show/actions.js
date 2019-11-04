import { handling } from '../../../../helpers/errorsHandling'
import { createPage, deletePage, loadGame } from '../../api'
import { ADD_PAGE, DELETE_PAGE, GAME_LOADED } from '../mutation-types'

export default {
  async loadGame({ commit }, id) {
    try {
      const game = await loadGame(id)
      commit(GAME_LOADED, game)
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

  async deletePage({ commit, state }, index) {
    try {
      const game = state.info
      await deletePage({ game_id: game.id, id: game.pages[index].id })
      commit(DELETE_PAGE, index)
    } catch (error) {
      handling(commit, error)
    }
  },
}
