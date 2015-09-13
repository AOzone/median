#
# /contract/:id
#

express = require "express"
routes = require "./routes"

app = module.exports = express()
app.set "views", __dirname + "/templates"
app.set "view engine", "jade"
app.get "/contract/:id", routes.show
app.get "/contract/:id/:transaction(buy|sell)", routes.order
app.post "/contract/:id/:transaction(buy|sell)/confirm", routes.transaction