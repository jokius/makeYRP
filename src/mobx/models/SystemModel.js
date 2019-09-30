import { observable } from 'mobx'
import { handling } from '../../shared/helpers/erros'
import req from '../../shared/helpers/request'
import dbLinks from '../../shared/helpers/dbLinks'

export default class SystemModel {
  @observable state = 'new'

  @observable _id = ''

  @observable name = ''

  constructor(params = {}) {
    const {
      state = 'new',
      _id = '',
      name = '',
    } = params
    this._id = _id
    this.state = state
    this.name = name
  }

  setNew = () => this.state = 'new'

  createFields = {
    fields: {
      raw: {
        label: 'JSON файл',
      },
    },
  }

  create = async (params) => {
    this.token = ''
    this.state = 'pending'
    try {
      await this.createReq(JSON.parse(params.raw))
      this.state = 'done'
    } catch (error) {
      handling(this, error)
    }
  }

  createReq = (raw) =>
    req.post(dbLinks.base.systems, { body: { ...raw } }).then(body => body)

  setInfo = (raw) => {
    this._id = raw._id
    this.name = raw.name
    this.state = 'done'

    return this
  }
}
