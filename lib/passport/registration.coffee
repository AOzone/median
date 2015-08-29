LocalStrategy = require('passport-local').Strategy
User = require '../../db/models/user'
bCrypt = require 'bcrypt-nodejs'

module.exports = (passport) ->

  passport.use 'signup', new LocalStrategy {
    passReqToCallback: true
  }, (req, username, password, done) ->
    findOrCreateUser = ->
      User.findOne { 'username' :  username }, (err, user) ->

        # In case of any error, return using the done method
        if err
          console.log "Error in SignUp: #{err}"
          return done err

        # user already exists
        if user
          console.log "User already exists with username: #{username}"
          return done null, false, req.flash 'message','User Already Exists'

        else
          # if there is no user with that email
          # create the user
          newUser = new User()

          # set the user's local credentials
          newUser.username = username;
          newUser.password = createHash password
          newUser.email = req.param 'email'
          newUser.gender = req.param 'gender'
          newUser.age = req.param 'age'
          # save the user
          newUser.save (err) ->
            if err
              console.log "Error in saving user: #{err}"
              throw err;

            console.log 'User Registration succesful'
            done null, newUser

      # Delay the execution of findOrCreateUser and execute the method
      # in the next tick of the event loop
      process.nextTick findOrCreateUser

    # Generates hash using bCrypt
    createHash = (password) ->
      bCrypt.hashSync password, bCrypt.genSaltSync(10), null