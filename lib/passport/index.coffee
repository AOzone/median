login = require './login'
registration = require './registration'
User = require '../../db/models/user'
Account = require '../../models/account'
_ = require 'underscore'
Q = require 'q'

module.exports = (passport, app) ->
  app.use passport.initialize()
  app.use passport.session()

  # Passport needs to be able to serialize and deserialize users
  # to support persistent login sessions
  passport.serializeUser (user, done) ->
    console.log 'serializing user: ', user
    done null, user.get('_id')

  passport.deserializeUser (id, done) ->
    User.findById id, (err, user) ->
      if err or !user
        console.log "Error logging in #{err}"
        return done err, null, message: 'Error fetching user. Try again or contact azone@guggenheim.org'

      account = new Account id: user?.username
      account.fetch
        success: (account, response)->
          done err, account.set
            _id: user.id
            username: user.username
        error: (account, error) ->
          done err, user

  login passport
  registration passport