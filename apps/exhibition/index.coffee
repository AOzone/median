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
app.get "/terminal/futures/defn", routes.futureDefinition
app.get "/terminal/futures/defn/:callsign", routes.futureDefinition
app.get "/terminal/bigboard", routes.allFutures
app.get "/terminal/bigboard/:callsign", routes.allFutures
app.get "/terminal/tips", routes.futureTips
app.get "/terminal/tips/:callsign", routes.futureTips
app.get "/terminal/news/tick", routes.futureTips
app.get "/terminal/news/tick/:callsign", routes.futureTips
app.get "/terminal/futures/tick", routes.futureTick
app.get "/terminal/futures/tick/:callsign", routes.futureTick
