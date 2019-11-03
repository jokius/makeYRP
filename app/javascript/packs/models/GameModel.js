import { UserModel } from './UserModel'
import { MenuModel } from './MenuModel'

export class GameModel {
  id = null
  name = ''
  master = {}
  users = []
  menus = []

  setInfo(raw) {
    this.id = raw.id
    this.name = raw.name
    this.master = new UserModel().setInfo(raw.master)
    this.users = (raw.users || []).map((user) => new UserModel().setInfo(user))
    this.menus = (raw.menus || []).map((menu) => new MenuModel().setInfo(menu))
    return this
  }
}
