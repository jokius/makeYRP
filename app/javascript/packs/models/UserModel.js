export class UserModel {
  id = null
  admin = false
  nickname = null
  avatar = null

  setInfo(raw) {
    this.id = raw.id
    this.nickname = raw.nickname
    this.avatar = raw.avatar
    this.admin = Boolean(raw.admin)
    return this
  }
}
