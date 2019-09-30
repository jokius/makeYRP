import request from 'superagent'
import { stringify } from 'qs'
import { InitState } from '../../../mobx/InitState'

export const applyOptions = (options) => {
  const store = new InitState({})
  const req = request(options.method, options.url)

  if (options.headers) {
    req.set(options.headers)
  }

  options.query = options.query || {}

  if (store.auth.token !== '') {
    options.query.token = store.auth.token
  }

  if (options.query) {
    req.query(stringify(options.query, { arrayFormat: 'brackets' }))
  }

  if (options.body && !options.file) {
    req.send(options.body)
  }

  if (options.file) {
    req.attach('image', options.file)
  }

  return req
}
