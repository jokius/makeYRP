import axios from 'axios'

export const signInReq = (user) => axios.post('/users/sign_in', { user })
export const signUpReq = (user) => axios.post('/users', { user })
