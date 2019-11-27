import { UserModel } from './UserModel'

export class MessageModel {
  id = null
  body = {}
  created_at = ''
  user = {}

  setInfo(raw) {
    this.id = raw.id
    this.body = raw.body
    this.createdAt = raw.created_at
    this.user = new UserModel().setInfo(raw.user)

    return this
  }
}
