export class FolderModel {
  id = null
  name = ''
  parentId = null
  children = []
  images = []

  setInfo(raw) {
    this.id = raw.id
    this.name = raw.name
    this.parentId = raw.parent_id
    this.children = raw.children
    this.images = raw.images
    return this
  }

  updateChild(obj) {
    const child = this.children.find((item) => item.id === obj.id)
    child.name = obj.name
    return this
  }

  deleteChild(id) {
    this.children = this.children.filter((child) => child.id !== id)
    return this
  }

  updateImage(obj) {
    const image = this.images.find((item) => item.id === obj.id)
    image.name = obj.name
    return this
  }

  deleteImage(id) {
    this.images = this.images.filter((image) => image.id !== id)
    return this
  }
}
