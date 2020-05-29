import links from '../lib/links'

export const loadTokens = ({ axios, page_id }) =>
  axios
    .get(links.json(links.dynamic(links.base.tokens, { page_id })))
    .then(response => response.data)

export const loadGraphics = ({ axios, page_id }) =>
  axios
    .get(links.json(links.dynamic(links.base.graphics, { page_id })))
    .then(response => response.data)
