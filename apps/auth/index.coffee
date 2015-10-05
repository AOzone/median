#
# / (auth requests)
#

express = require "express"
passport = require 'passport'
genders = require '../../maps/genders'

app = module.exports = express()
app.set "views", __dirname + "/templates"
app.set "view engine", "jade"

app.get '/login', (req, res) ->
  res.render 'login', message: req.flash 'error'

app.post '/login', passport.authenticate 'login',
  successRedirect: '/portfolio'
  failureRedirect: '/login'
  failureFlash: true

app.get '/signup', (req, res) ->
  res.render 'register',
    message: req.flash 'error'
    genders: genders

app.post '/signup', passport.authenticate 'signup',
  successRedirect: '/market'
  failureRedirect: '/signup'
  failureFlash: true

app.get '/logout', (req, res) ->
  req.logout()
  res.redirect('/')

# include user object on all templates
app.use (req, res, next) ->
  res.locals.user = req.user
  next()