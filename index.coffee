#
# Main app file. Loads the .env file, runs setup code, and starts the server.
# This code should be kept to a minimum. Any setup code that gets large should
# be abstracted into modules under /lib.
#
express = require "express"
setup = require "./lib/setup"
cache = require './lib/cache'
{ RESTART_INTERVAL } = require "./config"

app = module.exports = express()

cache.setup ->
  setup app

  app.listen process.env.PORT, ->
    console.log "Listening on port " + process.env.PORT
    process.send? "listening"


# Reboot for memory leak
setTimeout process.exit, RESTART_INTERVAL
