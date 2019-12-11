import Vue from 'vue'

import App from './components/app.vue'
import router from './helpers/router'
import store from './helpers/store'
import vuetify from './plugins/vuetify'

require('./plugins/axios')
require('./plugins/actioncable')
require('./plugins/chat_scroll')
require('./plugins/zoomer')

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
