#
# /accounts
#

express = require "express"
routes = require "./routes"

app = module.exports = express()
app.set "views", __dirname + "/templates"
app.set "view engine", "jade"
app.get '/leaderboard', (req, res) -> res.redirect '/leaderboard/forecasters'
app.get '/leaderboard/forecasters', routes.forecasters
app.get '/leaderboard/influencers', routes.influencers
app.get '/leaderboard/activists', routes.activists
