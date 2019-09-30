import Loadable from 'react-loadable'
import links from './shared/helpers/links'
import { Loading } from './modules/Loading'

const routes = [
  {
    path: '/',
    exact: true,
    component: Loadable({
      loader: () => import('./modules/Auth/pages/LoginPage'),
      loading: Loading,
    }),
    withoutAuth: true,
    redirectTo: links.base.games,
  },

  {
    path: links.base.registration,
    exact: true,
    component: Loadable({
      loader: () => import('./modules/Auth/pages/RegistrationPage'),
      loading: Loading,
    }),
    withoutAuth: true,
    redirectTo: links.base.games,
  },

  {
    path: links.base.games,
    exact: true,
    component: Loadable({
      loader: () => import('./modules/Games/pages/GamesListPage'),
      loading: Loading,
    }),
  },

  {
    path: links.base.newGame,
    exact: true,
    component: Loadable({
      loader: () => import('./modules/Games/pages/NewGamePage'),
      loading: Loading,
    }),
  },

  {
    path: links.base.game,
    exact: true,
    component: Loadable({
      loader: () => import('./modules/Games/pages/GamePage'),
      loading: Loading,
    }),
    initialAction: (store) => (match) => {
      store.game.setId(match.params.id)
    },
  },

  {
    path: links.base.newSystem,
    exact: true,
    component: Loadable({
      loader: () => import('./modules/Games/pages/NewSystemPage'),
      loading: Loading,
    }),
  },
]

export default routes
