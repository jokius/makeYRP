import System from '../models/systemModel'
import { isEmpty } from 'lodash'

module.exports = (app) => {
  app.get('/db/systems', (req, res) => {
    System.find({}, '_id name').then(systems => {
      res.send(systems)
    })
  })

  app.post('/db/systems', (req, res) => {
    if (!req.body || isEmpty(req.body)) {
      res.status(400)
      return res.send(['body Empty'])
    }

    const params = req.body
    System.findOne({ name: params.info.name.current })
      .then(system => {
        if (system) {
          if (system.version === params.version) {
            return res.sendStatus(204)
          }

          System.update(
            { _id: system._id },
            {
              version: params.version,
              template: params,
            },
          )
            .then(() => res.sendStatus(204))
        } else {
          System.create({
            name: params.info.name.current,
            version: params.version,
            template: params,
          })
            .then(() => res.sendStatus(204))
        }
      })
  })
}
