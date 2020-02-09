import wysiwyg from "vue-wysiwyg"
import Vue from 'vue'

(function() {
  Vue.use(wysiwyg, {
    hideModules: {
      link: true,
    },
  })
}())
