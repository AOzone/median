express = require 'express'
routes = require './routes'

app = module.exports = express()
app.set 'views', "#{__dirname}/templates"
app.set 'view engine', 'jade'

app.get '/information', (req, res) -> res.redirect '/information/about'
app.get '/information/about', routes.about
app.get '/information/contact', routes.contact
app.get '/information/press', routes.press
app.get '/information/glossary', routes.glossary
app.get '/information/terms', routes.terms
