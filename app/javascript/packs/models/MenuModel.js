export class MenuModel {
  id = null
  name = ''
  params = {}

  setInfo(raw) {
    this.id = raw.id
    this.name = raw.name
    this.params = raw.params
    return this
  }
}
