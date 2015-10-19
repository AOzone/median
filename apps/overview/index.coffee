express = require 'express'
routes = require './routes'

app = module.exports = express()
app.set 'views', "#{__dirname}/templates"
app.set 'view engine', 'jade'

app.get '/overview', (req, res) -> res.redirect '/overview/about'
app.get '/overview/about', routes.about
app.get '/overview/contact', routes.contact
app.get '/overview/credits', routes.credits
app.get '/overview/glossary', routes.glossary
app.get '/overview/terms', routes.terms
app.get '/contributors', routes.contributors
