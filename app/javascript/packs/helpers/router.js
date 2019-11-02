import Vue from 'vue'
import VueRouter from 'vue-router'

import links from './links'

Vue.use(VueRouter)

const routes = [
  {
    path: links.base.home,
    component: () => import('../components/Games/pages/Index'),
  },
  {
    path: links.base.signIn,
    component: () => import('../components/Authorization/pages/SignIn'),
  },
  {
    path: links.base.signUp,
    component: () => import('../components/Authorization/pages/SignUp'),
  },
  {
    path: links.base.newSystem,
    component: () => import('../components/Systems/pages/New'),
  },
  {
    path: links.base.games,
    component: () => import('../components/Games/pages/Index'),
  },
  {
    path: links.base.newGame,
    component: () => import('../components/Games/pages/New'),
  },
]

const router = new VueRouter({
  mode: 'history',
  routes,
})

export default router
