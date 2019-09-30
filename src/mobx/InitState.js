import { observable } from 'mobx'
import AuthModel from './models/AuthModel'
import GamesStore from './stores/GamesStore'
import GameModel from './models/GameModel'
import SystemsStore from './stores/SystemsStore'
import SystemModel from './models/SystemModel'

let instance = null

export class InitState {
  constructor(state = {}) {
    if (state.reset) {
      instance = null
    }

    if (!instance) {
      instance = this
    }

    this.state = state
    return instance
  }

  @observable cookies = this.state.cookies || null

  @observable redirectToLogin = false

  @observable auth = new AuthModel(this.state.auth || {})

  @observable formId = this.state.formId || null

  @observable games = new GamesStore(this.state.games || {})

  @observable game = new GameModel(this.state.game || {})

  @observable systems = new SystemsStore(this.state.systems || {})

  @observable system = new SystemModel(this.state.system || {})

  @observable openModals = []

  @observable leftMenus = []
}
