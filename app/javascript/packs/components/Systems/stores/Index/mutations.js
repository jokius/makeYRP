import {
  UPDATE_SYSTEMS,
} from '../mutation-types'

export default {
  [UPDATE_SYSTEMS](state, systems) {
    state.list = systems
    state.loaded = true
  },
}
