import { applyOptions } from './applyOptions'

const createResponseHandler = (req, options) => {
  const debug = `${options.method.toUpperCase()} ${options.url}`

  return new Promise((resolve, reject) => req.end((err, res) => {
    if (!res && !err) {
      throw new Error(`Connection failed ${debug}`)
    }

    options.onComplete()
    options.setLoading(false)

    if (err) {
      /* eslint-disable no-console */
      console.log('debug', debug)
      console.log('err', err)
      /* eslint-disable no-console */

      return reject({
        err,
        res,
      })
    }

    const { body: resData } = res

    options.onSuccess()

    return resolve(options.modifyResult(resData), res)
  }))
}


const defaultOptions = {
  withToken: false,
  modifyResult: (resData) => resData,
  onSuccess: () => {},
  onStart: () => {},
  onComplete: () => {},
  setLoading: () => {},
}

/**
 *
 * @param {{method: *, url: *}} requestOptions
 * @param {String} requestOptions.url
 * @param {String} requestOptions.method
 * @param {Object} requestOptions.headers
 * @param {Object} requestOptions.query
 * @param {Object} requestOptions.body
 */
const initRequest = (requestOptions) => {
  const options = { ...defaultOptions, ...requestOptions }

  options.onStart()
  options.setLoading(true)

  const req = applyOptions(options)
  const responseHandler = createResponseHandler(req, options)

  responseHandler.abort = req.abort.bind(req)

  return responseHandler
}

const requestByMethod = (method) => (url, options = {}) => (
  initRequest({ ...options, url, method })
)

const req = {
  get: requestByMethod('get'),
  post: requestByMethod('post'),
  patch: requestByMethod('patch'),
  put: requestByMethod('put'),
  delete: requestByMethod('delete'),
  upload: requestByMethod('post'),
}

export default req
