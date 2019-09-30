import { mapValues } from 'lodash'

const baseApi = '/'
const createLinks = (links) => mapValues(links, (link => `${baseApi}${link}`))

const links = {
  base: createLinks({
    registration: 'registration',
    games: 'games',
    newGame: 'games/new',
    game: 'games/:id',
    newSystem: 'systems/new',
  }),

  dynamic: (link, params) => {
    let resultLink = link
    Object.keys(params).forEach(parameter => resultLink = resultLink.replace(`:${parameter}`,
      params[parameter]))
    return resultLink
  },
}

export default links
