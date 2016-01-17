express = require 'express'
routes = require './routes'

app = module.exports = express()
app.set 'views', "#{__dirname}/templates"
app.set 'view engine', 'jade'

app.get '/goods', routes.goods
app.get '/goods/:good_id', routes.good

app.post '/goods/purchase/:good_id', routes.makePurchase
