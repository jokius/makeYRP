import { observable } from 'mobx'
import { handling } from '../../shared/helpers/erros'
import req from '../../shared/helpers/request'
import dbLinks from '../../shared/helpers/dbLinks'
import SystemModel from '../models/SystemModel'

export default class SystemsStore {
  @observable state = 'new'

  @observable list = []

  @observable errors = []

  constructor(params = {}) {
    const {
      state = 'new',
      list = [],
      errors = [],
    } = params
    this.state = state
    this.list = list
    this.errors = errors
  }

  loadSystems = async () => {
    this.state = 'pending'
    try {
      return this.setSystems(await this.systemsReq())
    } catch (error) {
      handling(this, error)
    }
  }

  setSystems = (raw) => {
    this.list = raw.map(system => new SystemModel().setInfo(system))
    this.state = 'done'

    return this
  }

  systemsReq = () =>
    req.get(dbLinks.base.systems)
}
