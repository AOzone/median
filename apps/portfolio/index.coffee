#
# /portfolio

express = require "express"
routes = require "./routes"

app = module.exports = express()
app.set "views", __dirname + "/templates"
app.set "view engine", "jade"
app.get "/portfolio", routes.index
app.get "/portfolio/:id", routes.index