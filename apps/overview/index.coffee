#
# /
# (info requests)
#

express = require "express"
routes = require "./routes"

app = module.exports = express()
app.set "views", __dirname + "/templates"
app.set "view engine", "jade"
app.get "/overview", routes.index
app.get "/overview/:page", routes.page
