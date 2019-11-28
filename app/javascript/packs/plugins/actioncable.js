import ActionCableVue from 'actioncable-vue'
import Vue from 'vue'

(function() {
  Vue.use(ActionCableVue, {
    debug: true,
    debugLevel: 'error',
    connectionUrl: process.env.WEBSOCKET_HOST || 'ws://localhost:3000/cable',
    connectImmediately: true,
  })
}())
