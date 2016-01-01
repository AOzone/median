#
# /portfolio

express = require "express"
routes = require "./routes"

app = module.exports = express()
app.set "views", __dirname + "/templates"
app.set "view engine", "jade"
app.get "/portfolio", (req, res, next) -> res.redirect "/portfolio/#{req.user.id}"
app.get "/portfolio/:id", routes.index
app.get "/portfolio/:id/alerts", routes.alerts
app.get "/portfolio/:id/goods", routes.goods
