export class ItemMenuModel {
  id = null
  params = {}

  setInfo(raw) {
    this.id = raw.id
    this.params = raw.params
    return this
  }
}
