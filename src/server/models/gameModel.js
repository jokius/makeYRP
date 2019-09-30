import mongoose, { Schema } from 'mongoose'

const gameSchema = new Schema({}, { strict: false })
const Game = mongoose.model('games', gameSchema)

export default Game
