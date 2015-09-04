#
# Using ["The Twelve-Factor App"](http://12factor.net/) as a reference all
# environment configuration will live in environment variables. This file
# simply lays out all of those environment variables with sensible defaults
# for development.
#

module.exports =
  NODE_ENV: "development"
  PORT: 4000
  APP_URL: "http://localhost:4000"
  API_URL: "http://localhost:3000"
  S3_KEY: null
  S3_SECRET: null
  SESSION_SECRET: 'm3d1an'
  SESSION_COOKIE_MAX_AGE: 31536000000
  SESSION_COOKIE_KEY: 'median.session'
  MONGO_URL: 'mongodb://localhost/median'
  COOKIE_DOMAIN: null
  DEFAULT_CACHE_TIME: 3600
  GOOGLE_ANALYTICS_ID: null
  SENDGRID_API_KEY: null
  REDIS_URL: null
  KERNAL_API_URL: null
  ARENA_API_URL: 'http://api.are.na/v2'
  ARENA_TOKEN: null
  OPENING_CREDIT: 1000

env = require 'node-env-file'
env __dirname + '/.env'

# Override any values with env variables if they exist
for key, val of module.exports
  val = (process.env[key] or val)
  module.exports[key] = try JSON.parse(val) catch then val