#
# /
# (getting started requests)
#

express = require "express"
routes = require "./routes"

app = module.exports = express()
app.set "views", __dirname + "/templates"
app.set "view engine", "jade"
app.get "/getting-started/1", routes.one
app.get "/getting-started/2", routes.two
app.get "/getting-started/3", routes.three
