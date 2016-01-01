#
# Using ["The Twelve-Factor App"](http://12factor.net/) as a reference all
# environment configuration will live in environment variables. This file
# simply lays out all of those environment variables with sensible defaults
# for development.
#

module.exports =
  NODE_ENV: "development"
  PORT: 5000
  APP_URL: "http://localhost:5000"
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
  KERNAL_API_URL: "http://52.91.104.43"
  KERNAL_SECRET: null
  ARENA_API_URL: 'http://api.are.na/v2'
  ARENA_API_TOKEN: null
  OPENING_CREDIT: 10000
  S3_KEY: null
  S3_SECRET: null
  S3_BUCKET: null
  CDN_URL: null
  CAPTCHA_KEY: null
  CAPTCHA_SECRET: null
  RESTART_INTERVAL: 1000 * 60 * 60
  WORDPRESS_API_URL: 'https://public-api.wordpress.com/rest/v1.1/sites/azonemarket.wordpress.com'
  CENTRAL_BANK_ACCOUNT: 'Azone'

# Override any values with env variables if they exist
for key, val of module.exports
  val = (process.env[key] or val)
  module.exports[key] = try JSON.parse(val) catch then val
