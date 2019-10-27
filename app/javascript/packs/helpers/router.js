import Vue from 'vue'
import VueRouter from 'vue-router'

import links from './links'

Vue.use(VueRouter)

const routes = [
  {
    path: links.base.signIn,
    component: () => import('../components/pages/SignIn'),
  },
  {
    path: links.base.signUp,
    component: () => import('../components/pages/SignUp'),
  },
]

const router = new VueRouter({
  mode: 'history',
  routes,
})

export default router
