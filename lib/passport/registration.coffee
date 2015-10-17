LocalStrategy = require('passport-local').Strategy
User = require '../../db/models/user'
Account = require '../../models/account'
{ authTokenPair } = require '../util/token'
{ OPENING_CREDIT, KERNAL_API_URL  } = require '../../config.coffee'
bCrypt = require 'bcrypt-nodejs'
Q = require 'q'

module.exports = (passport) ->

  passport.use 'signup', new LocalStrategy {
    passReqToCallback: true
  }, (req, username, password, done) ->
    findOrCreateUser = ->
      User.findOne { 'username' :  username }, (err, user) ->

        # In case of any error, return using the done method
        if err
          console.log "Error in SignUp: #{err}"
          return done err, message: 'Error signing up. Try again or contact azone@guggenheim.org'

        # user already exists
        if user
          console.log "User already exists with username: #{username}"
          return done null, false, message: "User already exists with username: #{username}"

        else
          # if there is no user with that email
          # create the user
          newUser = new User()

          # set the user's local credentials
          newUser.username = username;
          newUser.password = createHash password
          newUser.email = req.param 'email'
          newUser.gender = req.param 'gender'
          newUser.birthday = req.param 'birthday'
          newUser.city = req.param 'city'

          # open the trading account
          { authId, authToken } = authTokenPair()
          account = new Account()
          account.url = "#{KERNAL_API_URL}/accounts/#{username}/open/#{OPENING_CREDIT}"
          account.url = "#{account.url}?auth_id=#{authId}&auth_token=#{authToken}"

          account.save null,
            success: (account, response)->
              if response.success
                newUser.save (err) ->
                  if err
                    console.log 'error creating user', err
                    return done err, message: 'Error signing up. Try again or contact azone@guggenheim.org'
                  done null, newUser
              else
                console.log 'error creating user', err, response
                done null, false, message: response.message
            error: (account, err, response) ->
              console.log 'Something went wrong during registration', account, err, response
              done null, false, message: response.message

    # Delay the execution of findOrCreateUser and execute the method
    # in the next tick of the event loop
    process.nextTick findOrCreateUser

    # Generates hash using bCrypt
    createHash = (password) ->
      bCrypt.hashSync password, bCrypt.genSaltSync(10), null
