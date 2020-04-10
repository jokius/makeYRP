export class GraphicModel {
  id = null
  layer = ''
  params = {}

  setInfo(raw) {
    this.id = raw.id
    this.layer = raw.layer
    this.params = raw.params
    return this
  }
}
