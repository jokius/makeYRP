import { observable } from 'mobx'
import { handling } from '../../shared/helpers/erros'
import { InitState } from '../InitState'
import req from '../../shared/helpers/request'
import dbLinks from '../../shared/helpers/dbLinks'
import dvr from 'mobx-react-form/lib/validators/DVR'
import validatorjs from 'validatorjs'
import { isEmpty } from 'lodash'

export default class AuthModel {
  @observable login = ''

  @observable password = ''

  @observable token = ''

  @observable name = ''

  @observable admin = false

  @observable state = 'new'

  @observable isAuth = false

  @observable errors = []

  constructor(params = {}) {
    const {
      login = '',
      token = '',
      password = '',
      name = '',
      admin = false,
    } = params
    this.login = login
    this.token = token
    this.password = password
    this.name = name
    this.admin = admin
  }

  registrationFields = {
    fields: {
      login: {
        label: 'Логин',
        rules: 'required',
      },
      password: {
        label: 'Пароль',
        rules: 'required',
      },
      name: {
        label: 'Отображаемое имя',
      },
    },
  }

  loginFields = {
    fields: {
      login: {
        label: 'Логин',
        rules: 'required',
      },
      password: {
        label: 'Пароль',
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

  registration = async (params) => {
    this.token = ''
    this.state = 'pending'
    try {
      this.setInfo(await this.registrationReq(params))
      this.state = 'done'
    } catch (error) {
      handling(this, error)
    }
  }

  logIn = async (params) => {
    this.token = ''
    this.state = 'pending'
    try {
      this.setInfo(await this.loginReq(params))
      this.state = 'done'
    } catch (error) {
      handling(this, error)
    }
  }

  loginByToken = async (token) => {
    if (isEmpty(token) || token === '') return this

    this.state = 'pending'
    try {
      this.setInfo(await this.loginByTokenReq(token))
      this.state = 'done'
    } catch (error) {
      handling(this, error)
    }
  }

  setInfo = (raw) => {
    if (isEmpty(raw)) return new AuthModel()

    const store = new InitState({})
    this.isAuth = true
    this.login = raw.login
    this.name = raw.name
    this.password = ''
    this.token = raw.token
    this.admin = raw.admin || false
    store.cookies.set('token', this.token, { path: '/' })
    this.state = this.token === '' ? 'pending' : 'done'
  }

  registrationReq = (params) =>
    req.post(dbLinks.base.users, { body: { ...params } }).then(body => body)

  loginReq = (params) =>
    req.post(dbLinks.base.login, { body: { ...params } }).then(body => body)

  loginByTokenReq = (token) =>
    req.post(dbLinks.base.loginByToken, { body: { token } })

  setNew = () => this.state = 'new'
}
