mongoose = require 'mongoose'

module.exports = mongoose.model 'User',
  username: String
  password: String
  email: String
  gender: String
  birthday: Date
  city: String
