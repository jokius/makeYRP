import axios from 'axios'

import links from '../../../helpers/links'

export const loadGames = (params) =>
  axios
    .get(links.base.home, { params })
    .then((response) => response.data)

export const createGame = (params) =>
  axios
    .post(links.base.games, params)
    .then((response) => response.data)
