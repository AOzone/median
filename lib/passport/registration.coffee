LocalStrategy = require('passport-local').Strategy
User = require '../../db/models/user'
Account = require '../../models/account'
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

          # open the trading account
          account = new Account _id: newUser.username

          newUser.save (err) ->
            if err
              console.log 'error creating user', err
              throw err

            account.save null,
              success: ->
                console.log 'User Registration succesful', newUser
                done null, newUser
              error: (account, err, response) ->
                console.log 'Something went wrong during registration', account, err, response
                done null, newUser

    # Delay the execution of findOrCreateUser and execute the method
    # in the next tick of the event loop
    process.nextTick findOrCreateUser

    # Generates hash using bCrypt
    createHash = (password) ->
      bCrypt.hashSync password, bCrypt.genSaltSync(10), null