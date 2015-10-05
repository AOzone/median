#
# /market/*
#

express = require "express"
routes = require "./routes"

app = module.exports = express()
app.set "views", __dirname + "/templates"
app.set "view engine", "jade"
app.get "/market", routes.futures
app.get "/market/futures", routes.futures
app.get "/market/funds", routes.funds
app.get "/market/indices", routes.indices