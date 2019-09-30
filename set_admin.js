const mongoose = require('mongoose')

const { Schema } = mongoose

const userSchema = new Schema({}, { strict: false })
const User = mongoose.model('users', userSchema)

const login = process.argv[2]
/* eslint-disable no-console */
mongoose
  .connect(
    'mongodb://mongo:27017/gm_forge',
    { useNewUrlParser: true },
  )
  .then(() => console.log('MongoDB Connected'))
  .catch(err => console.log(err))

User.update(
  { login },
  { admin: true },
  (err, numberAffected) => {
    console.log('numberAffected', numberAffected)
    mongoose.disconnect()
  },
)
/* eslint-disable no-console */
