import {
  UPDATE_TEXT,
  UPDATE_FILE,
  UPDATE_NAME,
} from '../mutation-types'

export default {
  [UPDATE_NAME](state, name) {
    state.name = name
  },

  [UPDATE_TEXT](state, text) {
    state.text = text
  },

  [UPDATE_FILE](state, files) {
    state.files = files
  },
}
