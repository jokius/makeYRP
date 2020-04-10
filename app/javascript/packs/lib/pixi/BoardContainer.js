import { Container, Graphics, Loader, Rectangle, TilingSprite } from 'pixi.js-legacy'

import { rgbToXhex } from '../rgbToXhex'

export class BoardContainer extends Container {
  sendGraphic = () => {}

  constructor({ name, observer, sendGraphic, addEvents = false }) {
    super()
    this.name = name
    this.width = this.windowWidth
    this.height = this.windowHeight
    this.hitArea = new Rectangle(0, 0, this.windowWidth, this.windowHeight)
    this.sortableChildren = true
    this.sendGraphic = sendGraphic
    observer.subscribe(this.#received)
    if (addEvents) this.addSelectEvents()
  }

  // getters

  get windowWidth() {
    return window.screen.width * window.devicePixelRatio
  }

  get windowHeight() {
    return window.screen.height * window.devicePixelRatio
  }

  // public

  clearEvents() {
    this.interactive = false
    this.buttonMode = false
    this
      .off('pointerdown')
      .off('pointermove')
      .off('pointerupoutside')
      .off('pointerup')
  }

  markInteractive() {
    this.clearEvents()
    this.interactive = true
    this.buttonMode = true
  }

  addSelectEvents() {
    this.markInteractive()
    this.cursor = 'default'
    this
      .on('pointerdown', e => this.#onSelectionStart(e))
      .on('pointermove', e => this.#onSelectionMove(e))
      .on('pointerupoutside', () => this.#onSelectionEnd())
      .on('pointerup', () => this.#onSelectionEnd())
  }

  addRectEvents() {
    this.markInteractive()
    this.cursor = 'crosshair'
    this
      .on('pointerdown', e => this.#onRectStart(e))
      .on('pointermove', e => this.#onRectMove(e))
      .on('pointerupoutside', () => this.#onRectEnd())
      .on('pointerup', () => this.#onRectEnd())
  }

  changeBackground(backgroundUrl, width, height) {
    if (!backgroundUrl) {
      return this.removeChildren()
    }

    const loader = new Loader()
    loader.add('background', backgroundUrl)

    loader.load((loader, resources) => {
      const texture = resources.background.texture
      const sprite = this.#backgroundSprite(texture)
      if (width) {
        sprite.scale.x = width / texture.orig.width
      } else {
        if (texture.orig.width > this.windowWidth) {
          this.width = texture.orig.width
        }
      }

      if (height) {
        sprite.scale.y = height / texture.orig.height
      } else {
        if (texture.orig.height > this.windowHeight) {
          this.height = texture.orig.height
        }
      }

      if (!this.getChildByName('background')) this.addChild(sprite)
    })
  }

  drawGrid(grid, width, height) {
    this.removeChildren()
    if (!grid.type) return

    if (grid.type === 'cell') {
      const rect = new Graphics()
      let offsetW = 1
      let offsetH = 1
      const wEl = Math.round(width / grid.width)
      const hEl = Math.round(height / grid.height)

      if (wEl >= hEl) {
        for (let contW = 1; wEl >= contW; contW++) {
          for (let contH = 1; hEl >= contH; contH++) {
            this.#cell(rect, grid, offsetW, offsetH)
            offsetH += grid.height
          }

          offsetH = 1
          offsetW += grid.width
        }
      } else {
        for (let contH = 1; hEl >= contH; contH++) {
          for (let contW = 1; wEl >= contW; contW++) {
            this.#cell(rect, grid, offsetW, offsetH)
            offsetW += grid.width
          }

          offsetW = 1
          offsetH += grid.height
        }
      }

      this.addChild(rect)
    }
  }

  // private

  #selectColor = 0x3F51B5
  #dragging = false
  #startPosition = {}
  #rect = {}
  #borderSize = 0
  #borderColor = {}
  #bodyColor = {}

  #received = ({ cursor, layer, borderSize, borderColor, bodyColor }) => {
    if (this.name === layer) {
      if (cursor === 'default') this.addSelectEvents()
      if (cursor === 'rect') {
        this.#borderSize = borderSize
        this.#borderColor = borderColor
        this.#bodyColor = bodyColor
        this.addRectEvents()
      }
    } else {
      this.clearEvents()
    }
  }

  #onSelectionStart = event => {
    this.#start(event)
    this.#drawSelectRect({ width: 0, height: 0 })
  }

  #onSelectionMove = event => {
    if (!this.#dragging) return

    this.#drawSelectRect(this.#move(event))
  }

  #onSelectionEnd = () => {
    this.removeChild(this.#rect)
    this.#dragging = false
  }

  #drawSelectRect = ({ width, height }) => {
    this.removeChild(this.#rect)
    this.#rect = new Graphics()
    this.#rect.lineStyle(1, this.#selectColor)
    this.#rect.beginFill(this.#selectColor, 0.2)
    this.#rect.drawRect(this.#startPosition.x, this.#startPosition.y, width, height)
    this.#rect.endFill()
    this.addChild(this.#rect)
  }

  #onRectStart = event => {
    this.#start(event)
    this.#drawRectRect({ width: 0, height: 0 })
  }

  #onRectMove = event => {
    if (!this.#dragging) return

    this.#drawRectRect(this.#move(event))
  }

  #onRectEnd = () => {
    this.#dragging = false
    this.sendGraphic({
      params: {
        width: this.#rect.width,
        height: this.#rect.height,
        startPosition: this.#startPosition,
        borderSize: this.#borderSize,
        borderColor: this.#borderColor,
        bodyColor: this.#bodyColor,
      },
      layer: this.name,
      type: 'graphic',
    })

    this.removeChild(this.#rect)
  }

  #drawRectRect = ({ width, height }) => {
    this.removeChild(this.#rect)
    this.#rect = new Graphics()
    this.#rect.lineStyle(this.#borderSize, rgbToXhex(this.#borderColor), this.#borderColor.a)
    this.#rect.beginFill(rgbToXhex(this.#bodyColor), this.#bodyColor.a)
    this.#rect.drawRect(this.#startPosition.x, this.#startPosition.y, width, height)
    this.#rect.endFill()
    this.addChild(this.#rect)
  }

  #start = event => {
    this.#startPosition = event.data.getLocalPosition(this)
    this.#dragging = true
  }

  #move = event => {
    const position = event.data.getLocalPosition(this)
    return { width: position.x - this.#startPosition.x, height: position.y - this.#startPosition.y }
  }

  #backgroundSprite = texture => {
    let sprite = this.getChildByName('background')
    if (sprite) {
      sprite.texture = texture
      sprite.width = texture.orig.width
      sprite.height = texture.orig.height
    } else {
      sprite = new TilingSprite(texture, texture.orig.width, texture.orig.height)
      sprite.name = 'background'
    }

    sprite.interactive = false
    return sprite
  }

  #cell = (rect, grid, offsetW, offsetH) => {
    rect.beginFill(0, 0)
    rect.lineStyle(1, rgbToXhex(grid.color), grid.color.a)
    rect.drawRect(offsetW, offsetH, grid.width - 1, grid.height - 1)
    rect.endFill()
  }
}
