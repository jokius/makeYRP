import links from '../lib/links'

export const AclUsers = ({ axios, params }) =>
  axios
    .get(links.base.acl, { params })
    .then(response => response.data)
