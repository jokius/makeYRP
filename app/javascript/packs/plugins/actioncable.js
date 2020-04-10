import ActionCableVue from 'actioncable-vue'
import Vue from 'vue'

(function() {
  Vue.use(ActionCableVue, {
    debug: true,
    debugLevel: 'error',
    connectionUrl: `${process.env.NODE_ENV === 'production' ? 'wss' : 'ws'}://${window.location.host}/cable`,
    connectImmediately: true,
  })
}())
