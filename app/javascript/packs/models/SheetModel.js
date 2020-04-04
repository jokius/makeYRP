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

  get imgUrl() {
    return get(this.params.img, 'versions.url', '/img/default/blank_char.png')
  }

  get imgChat() {
    return get(this.params.img, 'versions.chat', '/img/default/blank_char_50.png')
  }

  get imgThumb() {
    return get(this.params.img, 'versions.thumb', '/img/default/blank_char_200.png')
  }

  get imgLazy() {
    return get(this.params.img, 'versions.lazy', '/img/default/blank_char_10.png')
  }
}
