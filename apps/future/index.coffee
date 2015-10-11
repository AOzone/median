#
# /future/:id
#

express = require "express"
routes = require "./routes"

app = module.exports = express()
app.set "views", __dirname + "/templates"
app.set "view engine", "jade"
app.get "/market/futures/:id", routes.show
app.get "/market/futures/:id/:transaction(buy|sell)", routes.order
app.post "/market/futures/:id/:transaction(buy|sell)/confirm", routes.transaction