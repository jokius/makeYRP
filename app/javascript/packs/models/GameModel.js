import { UserModel } from './UserModel'
import { MenuModel } from './MenuModel'
import { PageModel } from './PageModel'

export class GameModel {
  id = null
  name = ''
  master = {}
  users = []
  menus = []
  pages = []
  template = {}

  setInfo(raw) {
    this.id = raw.id
    this.name = raw.name
    this.master = new UserModel().setInfo(raw.master)
    this.users = (raw.users || []).map((user) => new UserModel().setInfo(user))
    this.menus = (raw.menus || []).map((menu) => new MenuModel().setInfo(menu))
    this.pages = (raw.pages || []).map((page) => new PageModel().setInfo(page))
    this.template = raw.template || {}
    return this
  }

  addPage(page) {
    this.pages.push(new PageModel().setInfo(page))
    return this
  }

  deletePage(id) {
    this.pages = this.pages.filter((page) => page.id !== id)
    return this
  }

  get sheetTypes() {
    const types = []
    for (let [key, value] of Object.entries(this.template.actors)) {
      types.push({ value: key, text: value.name || key })
    }
    return types
  }
}
