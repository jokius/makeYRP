import { ItemMenuModel } from './ItemMenuModel'

export class MenuModel {
  id = null
  type = ''
  params = {}
  items = []

  setInfo(raw) {
    this.id = raw.id
    this.type = raw.type
    this.params = raw.params
    this.items = (raw.items || []).map(item => new ItemMenuModel().setInfo(item))
    return this
  }

  addItem(raw) {
    this.items.push(new ItemMenuModel().setInfo(raw))
  }
}
