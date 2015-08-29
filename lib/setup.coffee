#
# Sets up intial project settings, middleware, mounted apps, and
# global configuration such as overriding Backbone.sync and
# populating sharify data
#

{ APP_URL, API_URL, NODE_ENV, SESSION_SECRET,
SESSION_COOKIE_MAX_AGE, SESSION_COOKIE_KEY,
COOKIE_DOMAIN, GOOGLE_ANALYTICS_ID, SENDGRID_API_KEY,
MONGO_URL } = config = require "../config"

path = require 'path'
stylus = require "stylus"
nib = require "nib"
rupture = require 'rupture'
axis = require 'axis'
fs = require 'fs'
express = require 'express'
expressSession = require 'express-session'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
flash = require 'connect-flash'
bodyParser = require 'body-parser'
Backbone = require 'backbone'
sharify = require 'sharify'
sendgrid  = require('sendgrid')(SENDGRID_API_KEY) if SENDGRID_API_KEY

mongoose = require 'mongoose'
mongoose.connect MONGO_URL
passport = require 'passport'
initPassport = require './passport'

module.exports = (app) ->

  # Inject some configuration & constant data into sharify
  sd = sharify.data =
    API_URL: process.env.API_URL
    NODE_ENV: process.env.NODE_ENV
    JS_EXT: (if 'production' is process.env.NODE_ENV then '.min.js' else '.js')
    CSS_EXT: (if 'production' is process.env.NODE_ENV then '.min.css' else '.css')

  # Override Backbone to use server-side sync
  Backbone.sync = require 'backbone-super-sync'

  # Mount sharify
  app.use sharify
    # Development only
  if "development" is NODE_ENV
    # Compile assets on request in development
    app.use require("stylus").middleware
      src: path.resolve(__dirname, "../")
      dest: path.resolve(__dirname, "../public")
      compile: (str, path) ->
        stylus(str)
        .set('filename', path)
        .use(rupture())
        .use(axis())
        .use(require("nib")())

    app.use require("browserify-dev-middleware")
      src: path.resolve(__dirname, "../")
      transforms: [require("jadeify"), require('caching-coffeeify')]

  # More general middleware
  app.use express.static(path.resolve __dirname, "../public")

  # Test only
  if 'test' is sd.NODE_ENV
    # Mount fake API server
    app.use '/__api', require('../test/helpers/integration.coffee').api

  # Sessions
  app.use logger('dev')
  app.use bodyParser.json()
  app.use bodyParser.urlencoded(extended: true)
  app.use cookieParser()
  app.use expressSession secret: SESSION_SECRET
  app.use flash()

  # Passport
  initPassport passport, app

  # Mount apps
  app.use require "../apps/auth"
  app.use require "../apps/home"


