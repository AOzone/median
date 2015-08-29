LocalStrategy = require('passport-local').Strategy
User = require '../../db/models/user'
bCrypt = require 'bcrypt-nodejs'

module.exports = (passport) ->

  passport.use 'login', new LocalStrategy {
    passReqToCallback : true
  }, (req, username, password, done) ->
    User.findOne { 'username' :  username }, (err, user) ->
      return done(err) if err

      # Username does not exist, log the error and redirect back
      unless user
        console.log "User Not Found with username: #{username} "
        done null, false, req.flash 'message', 'User Not found.'

      # User exists but wrong password, log the error
      unless isValidPassword user, password
        console.log "Invalid Password"
        done null, false, req.flash 'message', 'Invalid Password'

      # User and password both match, return user from done method
      # which will be treated like success
      return done null, user

  isValidPassword = (user, password) ->
    bCrypt.compareSync password, user.password