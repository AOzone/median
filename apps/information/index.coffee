#
# /
# (info requests)
#

express = require "express"
routes = require "./routes"

app = module.exports = express()
app.set "views", __dirname + "/templates"
app.set "view engine", "jade"
app.get "/information", routes.index
app.get "/information/:page", routes.page
