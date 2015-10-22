Q = require 'bluebird-q'
_ = require 'underscore'
sd = require("sharify").data
News = require '../../collections/news.coffee'
Indices = require '../../collections/indices.coffee'
Contracts = require '../../collections/contracts.coffee'

@index = (req, res, next) ->
  contracts = new Contracts []
  indices = new Indices []

  Q.all [
    contracts.fetch()
    indices.fetch()
  ]
  .then ->
    res.locals.sd.CONTRACTS = contracts
    res.render 'index',
      contracts: contracts
      statement: indices.statement()
  .catch next
  .done()

@futureDefinition = (req, res, next) ->
  res.render 'definition'

@allFutures  = (req, res, next) ->
  contracts = new Contracts []

  Q.all [
    contracts.fetch()
  ]
  .then ->
    res.locals.sd.CONTRACTS = contracts
    res.render 'all_futures',
      contracts: contracts
  .catch next
  .done()

@futureTips = (req, res, next) ->
  res.render 'tips'

@futureTick = (req, res, next) ->
  res.render 'tick'
