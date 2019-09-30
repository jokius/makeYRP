import React from 'react'
import PropTypes from 'prop-types'
import Loadable from 'react-loadable'
import { Provider } from 'mobx-react'
import { CookiesProvider } from 'react-cookie'
import { StaticRouter } from 'react-router'
import { MuiThemeProvider } from '@material-ui/core'

import theme from '../theme'
import App from '../App'


const View = (props) => {
  const { modules, store, req, context } = props
  return (
    <Loadable.Capture report={moduleName => modules.push(moduleName)}>
      <Provider {...store}>
        <CookiesProvider cookies={store.cookies}>
          <StaticRouter location={req.url} context={context}>
            <MuiThemeProvider theme={theme.dark}>
              <App />
            </MuiThemeProvider>
          </StaticRouter>
        </CookiesProvider>
      </Provider>
    </Loadable.Capture>
  )
}

View.propTypes = {
  modules: PropTypes.array.isRequired,
  store: PropTypes.object.isRequired,
  req: PropTypes.object.isRequired,
  context: PropTypes.object.isRequired,
  generateClassName: PropTypes.string.isRequired,
}

export default View
