import { Container, Graphics, Loader, TilingSprite } from 'pixi.js'

import { rgbToXhex } from '../rgbToXhex'

export class BoardContainer extends Container {
  constructor({ interactive = false }) {
    super()
    this.width = this.windowWidth
    this.height = this.windowHeight
    this.interactive = interactive
    this.buttonMode = interactive
    if (interactive) {
      this.cursor = 'default'
      this
        .on('pointerdown', e => this.#onSelectionStart(e))
        .on('pointermove', e => this.#onSelectionMove(e))
        .on('pointerupoutside', () => this.#onSelectionEnd())
        .on('pointerup', () => this.#onSelectionEnd())
    }
  }

  // getters

  get windowWidth() {
    return window.screen.width * window.devicePixelRatio
  }

  get windowHeight() {
    return window.screen.height * window.devicePixelRatio
  }

  // public

  changeBackground(backgroundUrl, width, height) {
    if (!backgroundUrl) {
      return this.removeChildren()
    }

    const loader = new Loader()
    loader.add('background', backgroundUrl)

    loader.load((loader, resources) => {
      const texture = resources.background.texture
      const sprite = this.backgroundSprite(texture)
      if (width) {
        sprite.scale.x = width / texture.orig.width
      } else {
        if (texture.orig.width > this.windowWidth) {
          this.mapContainer.width = texture.orig.width
        }
      }

      if (height) {
        sprite.scale.y = height / texture.orig.height
      } else {
        if (texture.orig.height > this.windowHeight) {
          this.mapContainer.height = texture.orig.height
        }
      }

      if (!this.getChildByName('background')) this.addChild(sprite)
    })
  }

  backgroundSprite(texture) {
    let sprite = this.getChildByName('background')
    if (sprite) {
      sprite.texture = texture
      sprite.width = texture.orig.width
      sprite.height = texture.orig.height
    } else {
      sprite = new TilingSprite(texture, texture.orig.width, texture.orig.height)
      sprite.name = 'background'
    }

    return sprite
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

  #onSelectionStart = event => {
    this.#startPosition = event.data.getLocalPosition(this)
    this.#dragging = true
    this.#drawSelectRect(0, 0)
  }

  #onSelectionMove = event => {
    if (!this.#dragging) return

    const position = event.data.getLocalPosition(this)
    const width = position.x - this.#startPosition.x
    const height = position.y - this.#startPosition.y
    this.#drawSelectRect(width, height)
  }

  #onSelectionEnd = () => {
    this.removeChild(this.#rect)
    this.#dragging = false
  }

  #drawSelectRect = (width, height) => {
    this.removeChild(this.#rect)
    this.#rect = new Graphics()
    this.#rect.lineStyle(1, this.#selectColor)
    this.#rect.beginFill(this.#selectColor, 0.2)
    this.#rect.drawRect(this.#startPosition.x, this.#startPosition.y,
                        width, height)
    this.#rect.endFill()
    this.addChild(this.#rect)
  }

  #cell = (rect, grid, offsetW, offsetH) => {
    rect.beginFill(0, 0)
    rect.lineStyle(1, rgbToXhex(grid.color), grid.color.a)
    rect.drawRect(offsetW, offsetH, grid.width - 1, grid.height - 1)
    rect.endFill()
  }
}
