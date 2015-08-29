login = require './login'
signup = require './signup'
User = require '../../db/models/user'

module.exports = (passport, app) ->

  app.use passport.initialize()
  app.use passport.session()

  # Passport needs to be able to serialize and deserialize users
  # to support persistent login sessions
  passport.serializeUser (user, done) ->
      console.log 'serializing user: ', user
      done null, user._id

  passport.deserializeUser (id, done) ->
    User.findById id, (err, user) ->
      console.log 'deserializing user:', user
      done err, user

  login passport
  signup passport