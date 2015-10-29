Q = require 'bluebird-q'
_ = require 'underscore'
sd = require("sharify").data
News = require '../../collections/news.coffee'
Indices = require '../../collections/indices.coffee'
Contracts = require '../../collections/contracts.coffee'
Contract = require '../../models/contract.coffee'
Chart = require '../../collections/chart.coffee'
Blocks = require '../../collections/blocks.coffee'
contractMap = require '../../maps/contracts.coffee'

pickRandomCallsign = ->
  signs = _.keys contractMap
  (_.shuffle signs)[0]

@index = (req, res, next) ->
  contracts = new Contracts []
  indices = new Indices []

  Q.all [
    contracts.fetch cache: true
    indices.fetch cache: true
  ]
  .then ->
    res.locals.sd.CONTRACTS = contracts
    res.render 'index',
      contracts: contracts
      statement: indices.statement()
  .catch next
  .done()

@futureDefinition = (req, res, next) ->
  callSign = req.params.callsign?.toUpperCase() || pickRandomCallsign()
  contract = new Contract id: callSign

  Q.all [
    contract.fetch cache: true
  ]
  .then ->
    res.locals.sd.CONTRACT = contract.toJSON()

    res.render 'definition',
      contract: contract
  .catch next
  .done()

@allFutures  = (req, res, next) ->
  contracts = new Contracts []
  highlighted = req.params.callsign?.toUpperCase() || pickRandomCallsign()

  Q.all [
    contracts.fetch cache: true
  ]
  .then ->
    contracts.comparator = (contract) ->
      contract.get('title')
    contracts.sort()
    res.locals.sd.CONTRACTS = contracts

    res.render 'all_futures',
      contracts: contracts
      highlighted: highlighted
  .catch next
  .done()

@futureTips = (req, res, next) ->
  callSign = req.params.callsign?.toUpperCase() || pickRandomCallsign()
  channelId = contractMap[callSign]?.channel_id
  blocks = new Blocks [], id: channelId

  Q.all [
    blocks.fetch cache: true
  ]
  .then ->
    res.locals.sd.BLOCKS = blocks

    res.render 'tips',
      news: blocks
  .catch next
  .done()

@futureTick = (req, res, next) ->
  callSign = req.params.callsign?.toUpperCase() || pickRandomCallsign()
  contract = new Contract id: callSign
  chart = new Chart [], { id: callSign, type: '1tick' }

  Q.all [
    contract.fetch cache: true
    chart.fetch cache: true
  ]
  .then ->
    res.locals.sd.TICK_CHART = chart.toJSON()
    res.locals.sd.CONTRACT = contract.toJSON()

    res.render 'tick',
      contract: contract
      chart: chart
  .catch next
  .done()

@ticker = (req, res, next) ->
  blocks = new Blocks [], id: 'the-hottest-tips'
  contracts = new Contracts []

  Q.all [
    blocks.fetch cache: true
    contracts.fetch cache:true
  ]
  .then ->
    res.locals.sd.BLOCKS = blocks

    res.render 'ticker',
      news: blocks
      contracts: contracts
  .catch next
  .done()
