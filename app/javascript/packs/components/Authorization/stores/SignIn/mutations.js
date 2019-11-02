import {
  UPDATE_EMAIL,
  UPDATE_IS_VALID,
  UPDATE_PASSWORD,
} from '../mutation-types'

import { UPDATE_ERRORS } from '../../../../helpers/mutation-types'

export default {
  [UPDATE_IS_VALID](state, value) {
    state.isValid = value
  },

  [UPDATE_EMAIL](state, value) {
    state.email = value
    state.errors.email = []
  },

  [UPDATE_PASSWORD](state, value) {
    state.password = value
    state.errors.password = []
  },

  [UPDATE_ERRORS](state, value) {
    state.errors = value
    state.isValid = false
  },
}
