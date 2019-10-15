import Vue from 'vue'
import VueRouter from 'vue-router'
import Vuex from 'vuex'
import axios from 'axios'
import qs from 'qs'

import App from './components/app.vue'
import router from './helpers/router'
import store from './helpers/store'
import vuetify from './plugins/vuetify'

axios.defaults.headers.common = {
  Accept: 'application/json',
  'Content-Type': 'application/json; charset=utf-8',
  'X-CSRF-Token': document
    .querySelector('meta[name="csrf-token"]')
    .getAttribute('content'),
  'X-Requested-With': 'XMLHttpRequest',
}

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
  // .$mount(document.createElement('application'))
})
