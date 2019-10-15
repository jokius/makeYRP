import Vue from 'vue'
import Vuex from 'vuex'

import signUp from '../components/pages/SignUp/store'
import signIn from '../components/pages/SignIn/store'

Vue.use(Vuex)

export default new Vuex.Store({
  strict: process.env.NODE_ENV !== 'production',
  modules: {
    signUp: signUp,
    signIn: signIn,
  },
})
