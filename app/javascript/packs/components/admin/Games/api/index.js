import axios from 'axios'

import links from '../../../../helpers/links'

export const loadGames = () =>
  axios
    .get(links.json(links.base.adminGames))
    .then(response => response.data)

export const deleteGame = id =>
  axios
    .delete(links.dynamic(links.base.adminGame, { id }))
