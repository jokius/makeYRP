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

export const loadGame = (id) =>
  axios
    .get(links.dynamic(links.base.game, { id }))
    .then((response) => response.data)

export const createPage = (game_id, params) =>
  axios
    .post(links.dynamic(links.base.pages, { game_id }), params)
    .then((response) => response.data)

export const deletePage = (params) =>
  axios
    .delete(links.dynamic(links.base.page, { ...params }))

export const loadSheets = (game_id) =>
  axios
    .get(links.dynamic(links.base.sheets, { game_id }))
    .then((response) => response.data)

export const createSheet = (game_id, params) =>
  axios
    .post(links.dynamic(links.base.sheets, { game_id }), params)
    .then((response) => response.data)

export const deleteSheet = (game_id, id) =>
  axios
    .delete(links.dynamic(links.base.sheet, { game_id, id }))
