import {
  GAMES_LOADED,
} from '../mutation-types'
import { UPDATE_ERRORS } from '../../../../helpers/mutation-types'
import { GameModel } from '../../../../models/GameModel'

export default {
  [GAMES_LOADED](state, games) {
    state.open = games.open.map(game => new GameModel().setInfo(game))
    state.close = games.close.map(game => new GameModel().setInfo(game))
    state.loaded = true
  },

  [UPDATE_ERRORS](state, value) {
    state.errors = value
  },
}
