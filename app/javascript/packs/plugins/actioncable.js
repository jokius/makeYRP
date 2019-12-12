import ActionCableVue from 'actioncable-vue'
import Vue from 'vue'

(function() {
  const host = `${window.location.hostname}:${window.location.port}`
  Vue.use(ActionCableVue, {
    debug: true,
    debugLevel: 'error',
    connectionUrl: `ws://${host}/cable`,
    connectImmediately: true,
  })
}())
