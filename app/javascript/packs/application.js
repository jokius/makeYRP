import Vue from 'vue'
import axios from 'axios'
import qs from 'qs'

import App from './components/app.vue'
import router from './helpers/router'
import store from './helpers/store'
import vuetify from './plugins/vuetify'
import headers from './helpers/headers'

axios.defaults.headers.common = headers

axios.defaults.paramsSerializer = (params) =>
  qs.stringify(params, { arrayFormat: 'brackets' })

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
