import {
  CURRENT_USER_LOADED,
} from '../mutation-types'
import { UPDATE_ERRORS } from '../../../../helpers/mutation-types'
import { UserModel } from '../../../../models/UserModel'

export default {
  [CURRENT_USER_LOADED](state, user) {
    state.info = new UserModel().setInfo(user)
    state.loaded = true
  },

  [UPDATE_ERRORS](state, value) {
    state.errors = value
  },
}
