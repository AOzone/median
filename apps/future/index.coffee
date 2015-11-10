#
# /future/:id
#

express = require "express"
routes = require "./routes"
recaptcha = require "express-recaptcha"
{ CAPTCHA_KEY, CAPTCHA_SECRET } = require '../../config.coffee'

recaptcha.init CAPTCHA_KEY, CAPTCHA_SECRET

app = module.exports = express()
app.set "views", __dirname + "/templates"
app.set "view engine", "jade"
app.get "/investing/futures/:id", routes.show
app.get "/investing/futures/:id/tooltip", routes.tooltip
app.post "/investing/futures/:id/add_news", routes.addNews
app.post "/investing/futures/:id/:transaction(buy|sell)/confirm", recaptcha.middleware.verify, routes.transaction

# sigh
app.get "/transactions/:block_id", routes.transactions
