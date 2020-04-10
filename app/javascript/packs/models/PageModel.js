import { get } from 'lodash'

export class PageModel {
  static DEFAULT_COLOR = '#b3b3b3'
  static DEFAULT_UNIT = 70
  static DEFAULT_UNIT_COUNT = 25
  static DEFAULT_GRID_COLOR =  { r: 0, g: 0, b: 0, a: 0.2 }

  id = null
  name = ''
  params = {}
  defaultParams = {
    background: {
      color: PageModel.DEFAULT_COLOR,
    },
    width: PageModel.DEFAULT_UNIT * PageModel.DEFAULT_UNIT_COUNT,
    height: PageModel.DEFAULT_UNIT * PageModel.DEFAULT_UNIT_COUNT,
    grid: {
      width: PageModel.DEFAULT_UNIT,
      height: PageModel.DEFAULT_UNIT,
      color: PageModel.DEFAULT_GRID_COLOR,
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

  changeGridColor(color) {
    this.params.grid.color = color
    return this
  }

  get backgroundUrl() {
    return get(this.params, 'background.image.versions.url', null)
  }
}
