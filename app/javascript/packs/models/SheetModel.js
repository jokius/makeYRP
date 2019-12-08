import { get } from 'lodash'

export class SheetModel {
  id = null
  name = ''
  params = {}
  sheetType = ''

  setInfo(raw) {
    this.id = raw.id
    this.sheetType = raw.sheet_type
    this.name = raw.name
    this.params = raw.params
    return this
  }

  get imgThumb() {
    return get(this.params.img, 'versions.thumb', null)
  }

  get imgLazy() {
    return get(this.params.img, 'versions.lazy', null)
  }
}
