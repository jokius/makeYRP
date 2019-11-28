import axios from 'axios'
import qs from 'qs'

import headers from '../helpers/headers'

(function() {
  axios.defaults.headers.common = headers

  axios.defaults.paramsSerializer = (params) =>
    qs.stringify(params, { arrayFormat: 'brackets' })
}())
