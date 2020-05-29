import links from '../lib/links'

export const loadGames = ({ axios, params }) =>
  axios
    .get(links.base.games, { params })
    .then(response => response.data)

export const createGame = ({ axios, params }) =>
  axios
    .post(links.base.games, params)
    .then(response => response.data)

export const joinGame = ({ axios, id }) =>
  axios
    .post(links.dynamic(links.base.joinGame, { id }))
    .then(response => response.data)
