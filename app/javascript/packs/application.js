import Vue from 'vue'
import axios from 'axios'
import qs from 'qs'
import ActionCableVue from 'actioncable-vue'
import VueChatScroll from 'vue-chat-scroll'

import App from './components/app.vue'
import router from './helpers/router'
import store from './helpers/store'
import vuetify from './plugins/vuetify'
import headers from './helpers/headers'

axios.defaults.headers.common = headers

axios.defaults.paramsSerializer = (params) =>
  qs.stringify(params, { arrayFormat: 'brackets' })


Vue.use(ActionCableVue, {
  debug: true,
  debugLevel: 'error',
  connectionUrl: process.env.WEBSOCKET_HOST || 'ws://localhost:3000/cable',
  connectImmediately: true,
})

Vue.use(VueChatScroll)

document.addEventListener('DOMContentLoaded', () => {
  const el = document.body.appendChild(document.createElement('application'))
  new Vue({
    el,
    vuetify,
    router,
    store,
    render: (h) => h(App),
  })
})
