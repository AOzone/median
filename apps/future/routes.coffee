Q = require 'q'
_ = require 'underscore'
Backbone = require "backbone"
sd = require("sharify").data
Contract = require '../../models/contract.coffee'
Contracts = require '../../collections/contracts.coffee'
Chart = require '../../collections/chart.coffee'
Block = require '../../models/block.coffee'
Blocks = require '../../collections/blocks.coffee'
contractMap = require '../../maps/contracts.coffee'
transactionMap = require '../../maps/transactions.coffee'
title = require 'url-to-title'

fetchContract = (callSign, next, cb)->
  dfd = Q.defer()
  channelId = contractMap[callSign]?.channel_id

  return dfd.reject(message: 'Channel not found') unless channelId

  contract = new Contract id: callSign
  contracts = new Contracts []
  blocks = new Blocks [], id: channelId
  tick_chart = new Chart [], { id: callSign, type: '1tick' }

  Q.all([
    contract.fetch()
    contracts.fetch()
    blocks.fetch(cache: true)
    tick_chart.fetch()
  ]).then ->
    # set any additional metadata
    contract.set contractMap[callSign]

    dfd.resolve
      contract: contract
      contracts: contracts
      blocks: blocks
      chart: tick_chart

  .catch (err, message) ->
    dfd.reject err, message
  .done()

  dfd.promise

@show = (req, res, next) ->
  callSign = req.params.id
  fetchContract(callSign, next).then ({ contract, blocks, chart, contracts }) ->

    res.locals.sd.TICK_CHART = chart.toJSON()
    res.locals.sd.CONTRACT = contract.toJSON()
    res.locals.sd.ALL_CONTRACTS = contracts.toJSON()
    res.locals.sd.BLOCKS = blocks.toJSON()

    res.render 'contract',
      news: blocks
      contract: contract
      contracts: contracts
      chart: chart
      message: req.flash 'error'

  .catch next
  .done()

@addNews = (req, res, next) ->
  return next() unless req.user
  url = req.body.url
  callSign = req.params.id
  channelId = contractMap[callSign]?.channel_id
  blocks = new Blocks [], id: channelId
  block = new Block source: url

  title url, (err, title) ->
    blocks.create block.toJSON(),
      url: "#{sd.ARENA_API_URL}/channels/#{channelId}/blocks"
      wait: true
      success: (block) ->
        res.send JSON.stringify block_id: block.id, title: title
      error: res.backboneError

@transaction = (req, res, next) ->
  return next() unless req.user
  transaction = req.params.transaction

  callSign = req.params.id
  block_id = req.body.block_id

  fetchContract(callSign, next).then ({ contract, blocks }) ->

    { success, reason } = req.user.canMakeTransaction transaction, contract
    unless success
      req.flash 'error', reason
      return res.redirect "/market/futures/#{contract.id}"

    req.user.makeTransaction { transaction: transaction, contract: contract, block_id: block_id },
      success: (model, response)->
        unless response.success
          req.flash 'error', error
          return res.redirect "/market/futures/#{contract.id}"

        # refresh user balance
        req.logIn req.user, (err) ->
          res.redirect "/market/futures/#{contract.id}"
      error: (account, error)->
        req.flash 'error', error
        res.redirect "/market/futures/#{contract.id}"
  .catch next
  .done()



