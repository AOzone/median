Q = require 'bluebird-q'
_ = require 'underscore'
sd = require("sharify").data
News = require '../../collections/news.coffee'
Contracts = require '../../collections/contracts.coffee'

@index = (req, res, next) ->
  contracts = new Contracts []

  Q.all [
    contracts.fetch()
  ]
  .then ->
    res.locals.sd.CONTRACTS = contracts
    res.render 'index',
      contracts: contracts
  .catch next
  .done()
