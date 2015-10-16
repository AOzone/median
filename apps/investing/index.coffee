#
# /market/*
#

express = require "express"
routes = require "./routes"

app = module.exports = express()
app.set "views", __dirname + "/templates"
app.set "view engine", "jade"
app.get "/investing", routes.futures
app.get "/investing/futures", routes.futures
app.get "/investing/funds", routes.funds
app.get "/investing/indices", routes.indices
