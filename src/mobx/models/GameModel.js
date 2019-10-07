import { observable } from 'mobx'
import UserModel from './UserModel'
import { handling } from '../../shared/helpers/erros'
import req from '../../shared/helpers/request'
import dbLinks from '../../shared/helpers/dbLinks'
import dvr from 'mobx-react-form/lib/validators/DVR'
import validatorjs from 'validatorjs'

export default class GameModel {
  @observable state = 'new'

  @observable _id = ''

  @observable name = ''

  @observable system = ''

  @observable master = {}

  @observable users = []

  @observable pages = []

  @observable menus = []

  @observable currentPage = 0

  @observable currentMenu = -1

  @observable errors = []

  constructor(params = {}) {
    const {
      state = 'new',
      _id = '',
      name = '',
      system = '',
      users = [],
      template = {},
      pages = [],
      menus = [],
      currentPage = 0,
      currentMenu = -1,
    } = params
    this._id = _id
    this.state = state
    this.name = name
    this.system = system
    this.users = users
    this.template = template
    this.pages = pages
    this.menus = menus
    this.currentPage = currentPage
    this.currentMenu = currentMenu
  }

  setNew = () => this.state = 'new'

  createFields = {
    fields: {
      name: {
        label: 'Название',
        rules: 'required',
      },
      system: {
        label: 'Система',
        rules: 'required',
      },
    },
  }

  plugins = {
    dvr: dvr({
      package: validatorjs,
      extend: ($validator) => {
        const messages = $validator.validator.getMessages('en')

        messages.required = 'это поле обязательно'
        messages.required_if = 'это поле обязательно'
        $validator.validator.setMessages('en', messages)
      },
    }),
  }

  create = async (params = {}) => {
    this.state = 'pending'
    try {
      this.setInfo(await this.createReq(params))
      this.state = 'done'
    } catch (error) {
      handling(this, error)
    }
  }

  createReq = (params) =>
    req.post(dbLinks.base.games, { body: { ...params } })
      .then(body => body)

  load = async () => {
    this.state = 'pending'
    try {
      this.setInfo(await this.loadReq())
      this.state = 'done'
    } catch (error) {
      handling(this, error)
    }
  }

  loadReq = () =>
    req.get(dbLinks.dynamic(dbLinks.base.game, { id: this._id }))
      .then(body => body)

  get pageFields() {
    return {
      fields: {
        name: {
          label: 'Название',
          rules: 'required',
          value: this.pageObj.name || '',
        },
        width: {
          label: 'Ширина',
          value: this.pageObj.width || '1600',
          rules: 'required',
        },
        height: {
          label: 'Высота',
          value: this.pageObj.height || '1600',
          rules: 'required',
        },
        type: {
          label: 'Тип',
          rules: 'required',
          value: this.pageObj.type || 'map',
        },
        grid: {
          label: 'Вид сетки',
          value: this.pageObj.grid || '',
        },
        gridWidth: {
          label: 'Ширена клетки px',
          value: this.pageObj.gridWidth || 64,
          rules: 'required',
        },
        gridHeight: {
          label: 'Высота клетки px',
          value: this.pageObj.gridHeight || 64,
          rules: 'required',
        },
      },
    }
  }

  addPage = async (params) => {
    this.state = 'pending'
    try {
      this.pages.push(await this.addPageReq(params))
      this.currentPage = this.pages.length - 1
      this.state = 'done'
    } catch (error) {
      handling(this, error)
    }
  }

  addPageReq = (params) =>
    req.post(dbLinks.dynamic(dbLinks.base.pages, { id: this._id }), { body: { ...params } })
      .then(body => body)

  removePage = async (index) => {
    this.state = 'pending'
    try {
      const page = this.pages[index]
      await this.removePageReq(page)
      this.pages.remove(page)
      if (this.currentPage === index) this.currentPage = this.pages.length - 1
      this.state = 'done'
    } catch (error) {
      handling(this, error)
    }
  }

  removePageReq = (params) =>
    req.delete(dbLinks.dynamic(dbLinks.base.pages, { id: this._id }), { body: { ...params } })
      .then(body => body)

  changeBackgroundImage = async (file) => {
    this.state = 'pending'
    try {
      this.pageObj.backgroundImage = await this.changeBackgroundImageReq(file)
      this.state = 'done'
    } catch (error) {
      handling(this, error)
    }
  }

  changeBackgroundImageReq = (file) =>
    req.post(dbLinks.dynamic(dbLinks.base.page, {
      id: this._id,
      index: this.currentPage,
    }), { file })
      .then(body => body)

  changeBackgroundColor = async () => {
    try {
      await this.changePageReq({ backgroundColor: this.pageObj.backgroundColor })
      this.state = 'done'
    } catch (error) {
      handling(this, error)
    }
  }

  changePage = async (params) => {
    try {
      const page = this.pageObj
      await this.changePageReq(params)
      Object.assign(page, params)
      this.state = 'done'
    } catch (error) {
      handling(this, error)
    }
  }

  changePageReq = (params) =>
    req.put(dbLinks.dynamic(dbLinks.base.page, {
      id: this._id,
      index: this.currentPage,
    }), { body: { ...params } })
      .then(body => body)

  setInfo = (raw) => {
    this._id = raw._id
    this.system = raw.system
    this.name = raw.name
    this.master = new UserModel().setInfo(raw.master)
    this.users = (raw.users || {}).map(user => new UserModel().setInfo(user))
    this.pages = raw.pages || []
    this.menus = raw.menus || []
    this.currentPage = this.currentPage || 0
    this.currentMenu = this.currentMenu || 0
    this.state = 'done'

    return this
  }

  setId(id) {
    this._id = id
  }

  setCurrentPage(index) {
    this.currentPage = index
  }

  setCurrentMenu(index) {
    this.currentMenu = index
  }

  setPageBackgroundColor(color) {
    this.pageObj.backgroundColor = color.hex
  }

  get pageObj() {
    return this.pages.length > 0 ? this.pages[this.currentPage] || {} : {}
  }
}
