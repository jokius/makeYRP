import { mapValues } from 'lodash'

const baseApi = '/api/'
const createLinks = (links) => mapValues(links, ((link) => `${baseApi}${link}`))

const apiLinks = {
  base: createLinks({
    users: 'users',
  }),

  dynamic: (link, params) => {
    let resultLink = link
    Object.keys(params).forEach((parameter) => resultLink = resultLink.replace(`:${parameter}`,
      params[parameter]))
    return resultLink
  },
}

export default apiLinks
