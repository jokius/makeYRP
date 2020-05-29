import links from '../lib/links'

export const loadGame = ({ axios, id }) =>
  axios
    .get(links.json(links.dynamic(links.base.game, { id })))
    .then(response => response.data)


export const loadSheets = ({ axios, id }) =>
  axios
    .get(links.json(links.dynamic(links.base.sheets, { game_id: id })))
    .then(response => response.data)

export const loadMessages = ({ axios, id }) =>
  axios
    .get(links.json(links.dynamic(links.base.messages, { game_id: id })))
    .then(response => response.data)
