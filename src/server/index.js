import express from 'express'
import cookieParser from 'cookie-parser'
import { renderFile } from 'ejs'
import ReactDOMServer from 'react-dom/server'
import { ServerStyleSheets } from '@material-ui/styles'
import { useStaticRendering } from 'mobx-react'
import { matchPath } from 'react-router-dom'
import Loadable from 'react-loadable'
import { getBundles } from 'react-loadable/webpack'
import jsonStringifySafe from 'json-stringify-safe'
import { toJS } from 'mobx'
import CookiesMiddleware from 'universal-cookie-express'
import bodyParser from 'body-parser'

import routes from '../routes'
import View from './view'
import stats from '../../dist/react-loadable.json'
import { InitState } from '../mobx/InitState'
import { uniqueId } from 'lodash'
import mongoose from 'mongoose'

useStaticRendering(true)

const app = express()
app.use(bodyParser.json({ limit: '64mb' }))
app.use(bodyParser.urlencoded({
  limit: '64mb',
  extended: true,
}))
app.use(cookieParser())
app.use('/', express.static('dist'))
app.use('/public', express.static('public'))

//db
/* eslint-disable no-console */
mongoose
  .connect(
    'mongodb://mongo:27017/myrp',
    { useNewUrlParser: true },
  )
  .then(() => console.log('MongoDB Connected'))
  .catch(err => console.log(err));
/* eslint-disable no-console */

// Routes
require('./routes/usersRoutes')(app)
require('./routes/gamesRoutes')(app)
require('./routes/systemsRoutes')(app)

// Cookies
app.use(CookiesMiddleware())

// Views
app.set('views', 'public')
app.set('view engine', 'ejs')
app.engine('ejs', renderFile)

app.get('*', (req, res, next) => {
  const store = new InitState({ reset: true })
  const sheets = new ServerStyleSheets()

  store.cookies = req.universalCookies
  store.formId = uniqueId()
  const promises = []
  const route = routes.filter(item => matchPath(req.url, item))[0]
  const token = store.cookies.get('token')
  if (route && route.component) {
    if (!route.withoutAuth && !token) return res.redirect(301, '/')
    if (route.redirectTo && token) return res.redirect(301, route.redirectTo)

    if (route.initialAction) {
      promises.push(route.initialAction(store)(matchPath(req.url, route)))
    }
  }

  promises.push(store.auth.loginByToken(token))

  Promise.all(promises)
    .then(() => {
      const context = {}
      const modules = []

      const html = ReactDOMServer.renderToString(sheets.collect(View({
        modules,
        store,
        req,
        context,
      })))

      const bundles = getBundles(stats, modules)
        .filter(bundle => bundle.file.endsWith('.js'))

      const css = sheets.toString()
      res.render('index', {
        css,
        html,
        initialData: jsonStringifySafe(toJS(store)),
        bundles,
      })
    })
    .catch(next)
})

Loadable.preloadAll()
  .then(() => {
    /* eslint-disable no-console */
    app.listen(
      80,
      (_, error) => {
        if (error) {
          console.error(error)
        } else {
          console.info(
            '==> 🌎  Listening on port %s. Open up http://localhost:%s/ in your browser.',
            80, 80,
          )
        }
      },
    )
    /* eslint-enable no-console */
  })
