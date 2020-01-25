import { ItemMenuModel } from './ItemMenuModel'

export class MenuModel {
  id = null
  params = {}
  items = []

  setInfo(raw) {
    this.id = raw.id
    this.params = raw.params
    this.items = (raw.items || []).map(item => new ItemMenuModel().setInfo(item))
    return this
  }
}
