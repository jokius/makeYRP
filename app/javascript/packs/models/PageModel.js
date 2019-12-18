import { get } from 'lodash'

export class PageModel {
  id = null
  name = ''
  params = {}
  defaultParams = {
    background: {
      color: '#b3b3b3',
    },
  }

  setInfo(raw) {
    this.id = raw.id
    this.name = raw.name
    this.params = { ...this.defaultParams, ...raw.params }
    return this
  }

  changeBackgroundColor(color) {
    this.params.background.color = color
    return this
  }

  get backgroundUrl() {
    return get(this.params, 'background.image.versions.url', null)
  }
}
