import { UserModel } from './UserModel'

export class GameModel {
  id = null
  name = ''
  master = {}
  users = []

  setInfo(raw) {
    this.id = raw.id
    this.name = raw.name
    this.master = new UserModel().setInfo(raw.master)
    this.users = raw.users.map((user) => new UserModel().setInfo(user))
    return this
  }
}
