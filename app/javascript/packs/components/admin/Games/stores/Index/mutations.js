import {
  GAMES_ADMIN_LOADED,
  DELETE_GAME,
} from '../mutation-types'
import { GameModel } from '../../../../../models/GameModel'

export default {
  [GAMES_ADMIN_LOADED](state, games) {
    state.list = games.map(game => new GameModel().setInfo(game))
    state.loaded = true
  },

  [DELETE_GAME](state, id) {
    state.list = state.list.filter(item => item.id !== id)
  },
}
