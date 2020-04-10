import { UserModel } from './UserModel'

export class AclModel {
  id = null
  user = {}
  is_owner = false
  cam_read = false
  cam_write = false

  setInfo(raw) {
    this.id = raw.id
    this.user = new UserModel().setInfo(raw.user)
    this.isOwner = raw.is_owner
    this.camRead = raw.cam_read
    this.camWrite = raw.cam_write

    return this
  }
}
