import { mapValues } from 'lodash'

const baseApi = '/db/'
const createLinks = (links) => mapValues(links, (link => `${baseApi}${link}`))

const dbLinks = {
  base: createLinks({
    users: 'users',
    login: 'users/login',
    loginByToken: 'users/login_by_token',
    games: 'games',
    game: 'games/:id',
    pages: 'games/:id/pages',
    page: 'games/:id/pages/:index',
    systems: 'systems',
  }),

  dynamic: (link, params) => {
    let resultLink = link
    Object.keys(params).forEach(parameter => resultLink = resultLink.replace(`:${parameter}`,
      params[parameter]))
    return resultLink
  },
}

export default dbLinks
