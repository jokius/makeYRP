import axios from 'axios'

export const signUpReq = (user) => axios.post('/users', { user })
