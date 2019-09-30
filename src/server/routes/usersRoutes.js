import User from '../models/userModel'
import { isEmpty } from 'lodash'
import crypto from 'crypto'

module.exports = (app) => {
  const secret = process.env.SALT || 'genius'

  app.post('/db/users', (req, res) => {
    if (!req.body || isEmpty(req.body)) {
      res.status(400)
      return res.send(['body Empty'])
    }
    const params = req.body

    User.exists({ login: params.login })
      .then(exists => {
        if (exists) {
          res.status(400)
          return res.send(['Логин занят'])
        }

        params.password = crypto.createHmac('sha256', secret)
          .update(`${params.password}`)
          .digest('hex')
        params.token = Math.random()
          .toString(36)
          .substr(2)

        User.create(params)
          .then(() =>
            res.send({
              ...params,
              password: undefined,
            }))
      })
  })

  app.post('/db/users/login', (req, res) => {
    if (!req.body || isEmpty(req.body)) {
      res.status(400)
      return res.send(['body Empty'])
    }
    const params = req.body

    params.password = crypto.createHmac('sha256', secret)
      .update(`${params.password}`)
      .digest('hex')

    User.findOne({
      login: params.login,
      password: params.password,
    })
      .then(user => {
        if (!user) {
          res.status(400)
          return res.send(['Неправильный логи или пароль'])
        }

        return res.send({
          ...user._doc,
          password: undefined,
        })
      })
  })

  app.post('/db/users/login_by_token', (req, res) => {
    if (!req.body || isEmpty(req.body)) {
      res.status(400)
      return res.send(['body Empty'])
    }

    const { token } = req.body
    User.findOne({ token })
      .then(user => {
        if (!user) return res.send({})

        return res.send({
          ...user._doc,
          password: undefined,
        })
      })
  })
}
