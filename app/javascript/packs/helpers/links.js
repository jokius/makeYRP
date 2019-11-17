import { mapValues } from 'lodash'

const basePath = '/'
const createLinks = (links) => mapValues(links, ((link) => `${basePath}${link}`))

const links = {
  base: createLinks({
    home: '',
    signUp: 'users/sign_up',
    signIn: 'users/sign_in',
    currentUser: 'users/current',
    createGame: 'games/new',
    systems: 'systems',
    newSystem: 'systems/new',
    games: 'games',
    newGame: 'games/new',
    game: 'games/:id',
    pages: 'games/:game_id/pages',
    page: 'games/:game_id/pages/:id',
    sheets: 'games/:game_id/sheets',
    sheet: 'games/:game_id/sheets/:id',
  }),

  dynamic: (link, params) => {
    let resultLink = link
    Object.keys(params).forEach((parameter) => resultLink = resultLink.replace(`:${parameter}`,
      params[parameter]))
    return resultLink
  },
}

export default links