import { Loader, TilingSprite } from 'pixi.js'

export class Token {
  sheets = []
  grid = {}
  tokenRightMenu = {}
  container = {}
  showContainers = () => {}
  currentSelect = {}
  moveToken = () => {}


  constructor(sheets, grid, tokenRightMenu, container, showContainers,
              moveToken) {
    this.sheets = sheets
    this.grid = grid
    this.tokenRightMenu = tokenRightMenu
    this.container = container
    this.showContainers = showContainers
    this.moveToken = moveToken
  }

  addToken(token) {
    const loader = new Loader()
    const id = `token_${token.id}`
    const sheet = this.sheets.find(item => item.id === token.sheet_id)

    loader.add(id, sheet.imgUrl)

    loader.load((loader, resources) => {
      const texture = resources[id].texture
      const sprite = new TilingSprite(texture, texture.orig.width, texture.orig.height)
      const width = this.grid.width
      const height = this.grid.height
      sprite.name = id

      sprite.scale.x = width / texture.orig.width
      sprite.scale.y = height / texture.orig.height

      sprite.position.x = token.position_x
      sprite.position.y = token.position_y

      if (this.grid.type) {
        const width = this.grid.width
        const height = this.grid.height
        sprite.x -= sprite.x % width
        sprite.y -= sprite.y % height
      }

      sprite.interactive = true
      sprite.buttonMode = true
      sprite
        .on('pointerdown', e =>
          this.currentSelect = { sprite: sprite, id: token.id, dragging: true, data: e.data }
        )
        .on('pointermove', () => this.onDragMove())
        .on('pointerupoutside', () => this.onDragEnd())
        .on('pointerup', () => this.onDragEnd())
        .on('rightclick', () => this.tokenRightMenu(token.id))

      this.container.addChild(sprite)
      this.showContainers()
    })
  }

  changeToken(token) {
    const id = `token_${token.id}`
    const sprite = this.container.getChildByName(id)
    sprite.position.x = token.position_x
    sprite.position.y = token.position_y
  }

  onDragMove() {
    const { dragging = false, sprite, data } = this.currentSelect
    if (!dragging) return

    const newPosition = data.getLocalPosition(sprite.parent)
    sprite.alpha = 0.5
    sprite.anchor.set(0.5)
    sprite.x = newPosition.x
    sprite.y = newPosition.y
  }

  onDragEnd() {
    const { sprite, id } = this.currentSelect
    if (!sprite) return

    sprite.anchor.set(0)
    sprite.alpha = 1

    if (this.grid.type) {
      const width = this.grid.width
      const height = this.grid.height
      sprite.x -= sprite.x % width
      sprite.y -= sprite.y % height
    }

    this.moveToken({ position_x: sprite.x, position_y: sprite.y, id })
    this.currentSelect = {}
  }
}
