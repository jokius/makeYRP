import { Graphics, Rectangle } from 'pixi.js-legacy'

import { rgbToXhex } from '../rgbToXhex'

export class Graphic {
  rightMenu = {}
  currentSelect = {}
  move = () => {}

  constructor(rightMenu, move) {
    this.rightMenu = rightMenu
    this.move = move
  }

  add(graphic, container) {
    const { borderSize, borderColor, bodyColor, startPosition, width, height } = graphic.params
    const sprite = new Graphics()
    sprite.name = `graphic_${graphic.id}`
    sprite.lineStyle(borderSize, rgbToXhex(borderColor), borderColor.a)
    sprite.beginFill(rgbToXhex(bodyColor), bodyColor.a)
    sprite.drawRect(startPosition.x, startPosition.y, width, height)
    sprite.endFill()

    sprite.hitArea = new Rectangle(startPosition.x, startPosition.y, width, height)
    sprite.interactive = true
    sprite.buttonMode = true
    sprite
      .on('pointerdown', e =>
        this.currentSelect = { sprite, graphic, container, dragging: true, data: e.data }
      )
      .on('pointermove', () => this.onDragMove())
      .on('pointerupoutside', () => this.onDragEnd())
      .on('pointerup', () => this.onDragEnd())
      .on('rightclick', () => this.rightMenu(graphic.id))

    sprite.zIndex = container.children.length
    container.addChild(sprite)
  }

  change(graphic, container) {
    const id = `graphic_${graphic.id}`
    const sprite = container.getChildByName(id)
    const { startPosition } = graphic.params
    sprite.position.x = startPosition.x
    sprite.position.y = startPosition.y
  }

  onDragMove() {
    const { dragging = false, sprite, data, container } = this.currentSelect
    if (!dragging) return

    const newPosition = data.getLocalPosition(sprite.parent)
    sprite.zIndex = container.children.length
    sprite.alpha = 0.5
    sprite.x = newPosition.x - sprite.width
    sprite.y = newPosition.y - sprite.height
  }

  onDragEnd() {
    const { sprite, graphic } = this.currentSelect
    if (!sprite) return

    sprite.alpha = 1

    this.move({
      params: { ...graphic.params, startPosition: { x: sprite.x, y: sprite.y } },
      layer: graphic.layer,
      id: graphic.id,
      type: 'graphic' })
    this.currentSelect = {}
  }
}
