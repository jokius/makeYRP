export class AclModel {
  id = null
  masterId = null
  currentUserId = null
  writeAll = false
  readAll = false
  ownerId = null
  readIds = []
  writeIds = []

  setInfo(raw) {
    if (!raw) return this

    this.id = raw.id
    this.writeAll = raw.write_all
    this.readAll = raw.read_all
    this.ownerId = raw.owner_id
    this.readIds = raw.read_ids
    this.writeIds = raw.write_ids

    return this
  }

  isMaster() {
    return this.masterId === this.currentUserId
  }

  isOwner() {
    return this.ownerId === this.currentUserId
  }

  get canFull() {
    return this.isMaster() || this.isOwner()
  }

  get canWrite() {
    return this.isOwner() || this.writeAll || this.isMaster() || this.writeIds.includes(this.currentUserId)
  }

  get canRead() {
    return this.readAll || this.isMaster() || this.isOwner() || this.canWrite
      || this.readIds.includes(this.currentUserId)
  }
}
