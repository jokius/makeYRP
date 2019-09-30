import mongoose, { Schema } from 'mongoose'

const systemSchema = new Schema({}, { strict: false })
const System = mongoose.model('systems', systemSchema)

export default System
