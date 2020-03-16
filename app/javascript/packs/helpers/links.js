import { mapValues } from 'lodash'

const basePath = '/'
const createLinks = links => mapValues(links, (link => `${basePath}${link}`))

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
    sheets: 'games/:game_id/sheets',
    sheet: 'games/:game_id/sheets/:id',
    messages: 'games/:game_id/messages',
    folder: 'folder',
    folders: 'folders/:id',
    folderImages: 'folders/:folder_id/images',
    images: 'folders/:folder_id/images/:id',
    tokens: 'pages/:page_id/tokens',
    graphics: 'pages/:page_id/graphics',

    adminGames: 'admin/games',
    adminGame: 'admin/games/:id',
  }),

  dynamic: (link, params) => {
    let resultLink = link
    Object.keys(params).forEach(parameter => resultLink = resultLink.replace(`:${parameter}`,
      params[parameter]))
    return resultLink
  },

  json: link => `${link}.json`,
}

export default links
