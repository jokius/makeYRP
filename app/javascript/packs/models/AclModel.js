export class AclModel {
  id = null
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

  get isOwner() {
    return this.ownerId === this.currentUserId
  }

  get canWrite() {
    return this.writeIds.includes(id => this.currentUserId === id)
  }

  get canRead() {
    return this.isOwner || this.canWrite || this.readIds.includes(id => this.currentUserId === id)
  }
}
