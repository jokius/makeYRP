import axios from 'axios'

import links from '../../../helpers/links'

export const loadCurrentUser = (params) =>
  axios
    .get(links.base.currentUser, { params })
    .then((response) => response.data)
