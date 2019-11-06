import axios from 'axios'

import links from '../../../helpers/links'

export const addSystem = (params) => {
  const formData = new FormData()
  formData.append('file', params.files)
  formData.append('text', params.text)
  formData.append('name', params.name)

  return axios
    .post(links.base.systems, formData)
  }

export const loadSystems = () =>
  axios
    .get(links.base.systems)
    .then((response) => response.data)
