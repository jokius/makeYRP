import links from '../lib/links'

export const createFolder = ({ axios, params }) =>
  axios
    .post(links.base.folder, params)
    .then(response => response.data)

export const loadFolder = ({ axios, params }) =>
  axios
    .get(links.json(links.base.folder, { params }))
    .then(response => response.data)

export const updateFolder = ({ axios, params }) =>
  axios
    .put(links.dynamic(links.base.folders, params), { ...params })
    .then(response => response.data)

export const updateImage = ({ axios, params }) =>
  axios
    .put(links.dynamic(links.base.images, { id: params.id, folder_id: 0 }), { ...params })
    .then(response => response.data)

export const deleteFolder = ({ axios, id }) =>
  axios
    .delete(links.dynamic(links.base.folders, { id }))

export const deleteImage = ({ axios, id }) =>
  axios
    .delete(links.dynamic(links.base.images, { id, folder_id: 0 }))
