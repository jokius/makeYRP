import { observable } from 'mobx'
import { handling } from '../../shared/helpers/erros'
import req from '../../shared/helpers/request'
import dbLinks from '../../shared/helpers/dbLinks'
import GameModel from '../models/GameModel'

export default class GamesStore {
  @observable state = 'new'

  @observable open = []

  @observable close = []

  @observable errors = []

  constructor(params = {}) {
    const {
      state = 'new',
      open = [],
      close = [],
      errors = [],
    } = params
    this.state = state
    this.open = open
    this.close = close
    this.errors = errors
  }

  loadGames = async () => {
    this.state = 'pending'
    try {
      return this.setGames(await this.gamesReq())
    } catch (error) {
      handling(this, error)
    }
  }

  setGames = (raw) => {
    this.open = raw.open.map(game => new GameModel().setInfo(game))
    this.close = raw.close.map(game => new GameModel().setInfo(game))
    this.state = 'done'

    return this
  }

  gamesReq = () =>
    req.get(dbLinks.base.games)
}
