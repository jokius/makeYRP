import React from 'react'
import { hydrate } from 'react-dom'
import { Provider } from 'mobx-react'
import { BrowserRouter } from 'react-router-dom'
import Loadable from 'react-loadable'
import { omit } from 'lodash'
import { CookiesProvider } from 'react-cookie'
import { MuiThemeProvider } from '@material-ui/core/styles'
import { InitState } from '../mobx/InitState'
import theme from '../theme'
import App from '../App'

const initStore = omit(new InitState(window.__initialData__), ['state'])

window.main = () => {
  Loadable.preloadReady().then(() => {
    const jssStyles = document.querySelector('#jss-server-side');
    if (jssStyles) {
      jssStyles.parentNode.removeChild(jssStyles);
    }

    hydrate(
      <Provider {...initStore}>
        <CookiesProvider>
          <BrowserRouter>
            <MuiThemeProvider theme={theme.dark}>
              <App />
            </MuiThemeProvider>
          </BrowserRouter>
        </CookiesProvider>
      </Provider>,
      document.getElementById('root'),
    )
  })
}
