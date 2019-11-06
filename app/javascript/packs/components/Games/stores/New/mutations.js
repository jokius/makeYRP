import {
  UPDATE_ID,
  UPDATE_SYSTEM_ID,
  UPDATE_NAME,
} from '../mutation-types'

export default {
  [UPDATE_ID](state, id) {
    state.id = id
  },

  [UPDATE_NAME](state, name) {
    state.name = name
  },

  [UPDATE_SYSTEM_ID](state, system_id) {
    state.system_id = system_id
  },
}
