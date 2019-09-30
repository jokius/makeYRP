import React from 'react'
import { instanceOf } from 'prop-types'
import { Switch } from 'react-router'
import { Route } from 'react-router-dom'
import { withCookies, Cookies } from 'react-cookie'
import routes from './routes'
import { InitState } from './mobx/InitState'
import { inject, observer } from 'mobx-react'

@withCookies
@inject('redirectToLogin')
@observer
export default class App extends React.Component {
  static propTypes = {
    cookies: instanceOf(Cookies).isRequired,
  }

  componentDidMount() {
    const { cookies } = this.props
    if (typeof window !== 'undefined') {
      const store = new InitState({})
      store.cookies = cookies
    }
  }

  render() {
    return (
      <div>
        <Switch>
          {routes.map(route => <Route key={route.path || '404'} {...route} />)}
        </Switch>
      </div>
    )
  }
}
