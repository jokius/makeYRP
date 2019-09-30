import multer from 'multer'
import { isEmpty } from 'lodash'
import mkdirp from 'mkdirp'
import fs from 'fs'

import Game from '../models/gameModel'
import System from '../models/systemModel'
import User from '../models/userModel'

const upload = multer()

module.exports = (app) => {
  app.post('/db/games', (req, res) => {
    if (!req.body || isEmpty(req.body)) {
      res.status(400)
      return res.send(['body Empty'])
    }

    const { token } = req.query
    const { system, name } = req.body

    const promises = []
    promises.push(System.findOne({ _id: system }))
    promises.push(User.findOne({ token }, '_id name'))
    Promise.all(promises)
      .then(values => {
        const [systemDoc, user] = values
        Game.create({
          name,
          system: systemDoc.name,
          system_id: systemDoc._id,
          status: 'open',
          master_id: user._id,
          users: [],
        })
          .then(game => {
            res.status(201)
            res.send({
              ...game.toObject(),
              master: user,
              template: systemDoc.template,
            })
          })
      })
  })

  const gameOnList = (game) => {
    const promises = []
    promises.push(User.findById(game.master_id, 'name'))
    promises.push(User.find({ _id: game.users }, 'name'))
    return Promise.all(promises)
      .then(values => {
        const [master, users] = values
        return {
          _id: game._id,
          name: game.name,
          status: game.status,
          master: master.toObject(),
          users,
        }
      })
  }

  app.get('/db/games', (req, res) => {
    Game.find()
      .then(games => {
        Promise.all(games.map(game => gameOnList(game.toObject())))
          .then(list => {
            const open = list.filter(game => game.status === 'open')
            const close = list.filter(game => game.status === 'close')
            res.send({
              open,
              close,
            })
          })
      })
  })

  app.get('/db/games/:id', (req, res) => {
    Game.findById(req.params.id)
      .then(doc => {
        if (!doc) {
          return res.sendStatus(404)
        }

        const game = doc.toObject()

        const promises = []
        promises.push(User.findById(game.master_id, '_id name'))
        promises.push(User.find({ _id: game.users }, '_id name'))
        return Promise.all(promises)
          .then(values => {
            const [master, users] = values
            res.send({
              _id: game._id,
              name: game.name,
              status: game.status,
              pages: game.pages || [],
              master: master.toObject(),
              users,
            })
          })
      })
  })

  app.post('/db/games/:id/pages', (req, res) => {
    const page = req.body
    Game.update(
      { _id: req.params.id },
      { $push: { pages: page } },
    )
      .then(() => res.send(page))
  })

  app.delete('/db/games/:id/pages', (req, res) => {
    const page = req.body
    Game.update(
      { _id: req.params.id },
      { $pull: { pages: page } },
    )
      .then(() => res.sendStatus(204))
  })

  app.post('/db/games/:id/pages/:pageIndex', upload.single('image'), (req, res) => {
    const { id, pageIndex } = req.params
    const dirPath = `/public/uploads/games/${id}/pages`

    mkdirp(`.${dirPath}`, (err) => {
      if (err) {
        res.status(500)
        return res.send(err)
      }

      const filePath = `${dirPath}/${req.file.originalname}`
      fs.writeFileSync(`.${filePath}`, req.file.buffer)

      Game.findById(id)
        .then(doc => {
          if (!doc) {
            return res.sendStatus(404)
          }

          const game = doc.toObject()
          game.pages[pageIndex].backgroundImage = filePath
          doc.set({ ...game })
          doc.save()
            .then(() => res.send(filePath))
        })
    })
  })

  app.put('/db/games/:id/pages/:pageIndex', (req, res) => {
    const { id, pageIndex } = req.params
    const params = req.body

    Game.findById(id)
      .then(doc => {
        if (!doc) {
          return res.sendStatus(404)
        }

        const game = doc.toObject()
        const page = game.pages[pageIndex]
        game.pages[pageIndex] = { ...page, ...params }
        doc.set({ ...game })
        doc.save()
          .then(() => res.sendStatus(204))
      })
  })
}
