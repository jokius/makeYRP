import { mapValues } from 'lodash'

const basePath = '/'
const createLinks = (links) => mapValues(links, ((link) => `${basePath}${link}`))

const links = {
  base: createLinks({
    home: '',
    signUp: 'users/sign_up',
    signIn: 'users/sign_in',
  }),

  dynamic: (link, params) => {
    let resultLink = link
    Object.keys(params).forEach((parameter) => resultLink = resultLink.replace(`:${parameter}`,
      params[parameter]))
    return resultLink
  },
}

export default links