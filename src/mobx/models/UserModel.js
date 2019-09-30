import { observable } from 'mobx'

export default class UserModel {
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

  setInfo = (raw) => {
    this._id = raw._id
    this.system = raw.system
    this.name = raw.name
    this.state = 'done'

    return this
  }
}
