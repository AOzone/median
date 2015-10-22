#
# /
# (exhibition requests)
#

express = require "express"
routes = require "./routes"

app = module.exports = express()
app.set "views", __dirname + "/templates"
app.set "view engine", "jade"
app.get "/terminal/index", routes.index
app.get "/terminal/futures", routes.index
app.get "/terminal/futures/defn/:callsign", routes.futureDefinition
app.get "/terminal/bigboard/:sign", routes.allFutures
app.get "/terminal/futures/tips/:sign", routes.futureTips
app.get "/terminal/futures/tick/:sign", routes.futureTick
