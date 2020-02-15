import { UPDATE_ERRORS } from './mutation-types'

const handling = (commit, rawError) => {
  const error = rawError.response
  if (error) {
    switch (error.status) {
      case 400:
      case 422:
        commit(UPDATE_ERRORS, error.data.errors)
        return
      default:
        commit(UPDATE_ERRORS, { unknown: ['Look in the browser console'] })
    }
  }

  console.error('error', rawError.toString()) // eslint-disable-line no-console
}

export {
  handling,
}
