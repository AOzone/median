login = require './login'
registration = require './registration'
User = require '../../db/models/user'
Balance = require '../../models/balance'
Q = require 'q'

module.exports = (passport, app) ->

  app.use passport.initialize()
  app.use passport.session()

  # Passport needs to be able to serialize and deserialize users
  # to support persistent login sessions
  passport.serializeUser (user, done) ->
    console.log 'serializing user: ', user
    done null, user._id

  passport.deserializeUser (id, done) ->
    balance = new Balance id: id

    Q.all [
       User.findById id
       balance.fetch
    ]
    .spread (user, balance)->
      console.log 'hey man, a user and a balance', user, balance
      done err, user
    .catch ->


  login passport
  registration passport