import Vue from 'vue'
import wysiwyg from 'vue-wysiwyg'

if (process.client) {
  Vue.use(wysiwyg, {
    hideModules: {
      link: true,
    },
  })
}
