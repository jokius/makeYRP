import axios from 'axios'

import links from '../../../helpers/links'

export const loadGames = params =>
  axios
    .get(links.base.home, { params })
    .then(response => response.data)

export const createGame = params =>
  axios
    .post(links.base.games, params)
    .then(response => response.data)

export const loadGame = id =>
  axios
    .get(links.json(links.dynamic(links.base.game, { id })))
    .then(response => response.data)

export const loadSheets = game_id =>
  axios
    .get(links.json(links.dynamic(links.base.sheets, { game_id })))
    .then(response => response.data)

export const loadFolder = params =>
  axios
    .get(links.json(links.base.folder, { params }))
    .then(response => response.data)

export const createFolder = params =>
  axios
    .post(links.base.folder, params)
    .then(response => response.data)

export const deleteFolder = id =>
  axios
    .delete(links.dynamic(links.base.folders, { id }))

export const updateFolder = params =>
  axios
    .put(links.dynamic(links.base.folders, params), { ...params })
    .then(response => response.data)

export const deleteImage = id =>
  axios
    .delete(links.dynamic(links.base.images, { id, folder_id: 0 }))

export const updateImage = params =>
  axios
    .put(links.dynamic(links.base.images, { id: params.id, folder_id: 0 }), { ...params })
    .then(response => response.data)

export const loadMessages = game_id =>
  axios
    .get(links.json(links.dynamic(links.base.messages, { game_id })))
    .then(response => response.data)

export const createMenuItem = (game_id, params) =>
  axios
    .post(links.dynamic(links.base.menuItems, { game_id }), params)

export const updateMenuItem = (id, params) =>
  axios
    .put(links.dynamic(links.base.menuItem, { game_id: 0, id }), { params })

export const deleteMenuItem = id =>
  axios
    .delete(links.dynamic(links.base.menuItem, { game_id: 0, id }))

export const loadTokens = page_id =>
  axios
    .get(links.json(links.dynamic(links.base.tokens, { page_id })))
    .then(response => response.data)

export const loadGraphics = page_id =>
  axios
    .get(links.json(links.dynamic(links.base.graphics, { page_id })))
    .then(response => response.data)
