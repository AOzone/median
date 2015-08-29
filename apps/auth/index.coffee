#
# / (auth requests)
#

express = require "express"
passport = require 'passport'

app = module.exports = express()
app.set "views", __dirname + "/templates"
app.set "view engine", "jade"

app.get '/login', passport.authenticate 'login',
  res.render 'login', message: req.flash 'message'

app.post '/login', passport.authenticate 'login',
  successRedirect: '/'
  failureRedirect: '/'
  failureFlash: true

app.get '/signup', (req, res) ->
  res.render 'register', message: req.flash 'message'

app.post '/signup', passport.authenticate 'signup',
  successRedirect: '/home'
  failureRedirect: '/signup'
  failureFlash: true