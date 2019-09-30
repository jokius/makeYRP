import mongoose, { Schema } from 'mongoose'

const userSchema = new Schema({}, { strict: false })
const User = mongoose.model('users', userSchema)

export default User
