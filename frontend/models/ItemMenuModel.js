export class ItemMenuModel {
  id = null
  menuId = null
  params = {}

  setInfo(raw) {
    this.id = raw.id
    this.menuId = raw.menu_id
    this.params = raw.params
    return this
  }
}
