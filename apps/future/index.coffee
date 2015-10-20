#
# /future/:id
#

express = require "express"
routes = require "./routes"

app = module.exports = express()
app.set "views", __dirname + "/templates"
app.set "view engine", "jade"
app.get "/investing/futures/:id", routes.show
app.get "/investing/futures/:id/tooltip", routes.tooltip
app.post "/investing/futures/:id/add_news", routes.addNews
app.post "/investing/futures/:id/:transaction(buy|sell)/confirm", routes.transaction

# sigh
app.get "/transactions/:block_id", routes.transactions
