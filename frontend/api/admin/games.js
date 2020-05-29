import links from '../../lib/links'

export const loadGames = (axios) =>
  axios
    .get(links.json(links.base.adminGames))
    .then(response => response.data)

export const deleteGame = ({ axios, id }) =>
  axios
    .delete(links.dynamic(links.base.adminGame, { id }))
