import links from '../lib/links'

export const addSystem = ({ axios, params }) => {
  const formData = new FormData()
  formData.append('name', params.name)
  formData.append('file', params.file)
  formData.append('data_file', params.dataFile)
  formData.append('private_data_file', params.privateDataFile)

  return axios
    .post(links.base.systems, formData)
}

export const loadSystems = (axios) =>
  axios
    .get(links.json(links.base.systems))
    .then(response => response.data)
