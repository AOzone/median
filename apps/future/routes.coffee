Q = require 'bluebird-q'
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
{ getColor } = require '../../components/color/index.coffee'
title = require 'url-to-title'

fetchContract = (callSign, next, cb)->
  dfd = Q.defer()
  channelId = contractMap[callSign]?.channel_id

  return dfd.reject(message: 'Channel not found') unless channelId

  contract = new Contract id: callSign
  contracts = new Contracts []
  blocks = new Blocks [], id: channelId
  tickChart = new Chart [], { id: callSign, type: '1tick' }

  Q.all([
    contract.fetch()
    contracts.fetch()
    blocks.fetch(cache: true)
    tickChart.fetch()
  ]).then ->
    # set any additional metadata
    contract.set contractMap[callSign]

    dfd.resolve
      contract: contract
      contracts: contracts
      blocks: blocks
      chart: tickChart

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

    bgColor = getColor(contract.get('gain_percent'))

    res.render 'contract',
      news: blocks
      contract: contract
      contracts: contracts
      chart: chart
      message: req.flash 'error'
      bgColor: bgColor

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
        res.send block_id: block.id, title: title
      error: res.backboneError

@transaction = (req, res, next) ->
  return next() unless req.user
  transaction = req.params.transaction

  callSign = req.params.id
  block_id = req.body.block_id
  is_new = req.body.is_new
  comment = req.body.comment

  fetchContract(callSign, next).then ({ contract, blocks }) ->

    { success, reason } = req.user.canMakeTransaction transaction, contract
    unless success
      req.flash 'error', reason
      return res.redirect contract.href()

    req.user.makeTransaction { transaction: transaction, contract: contract, block_id: block_id, is_new: is_new, comment: comment },
      success: (model, response)->
        unless response.success
          req.flash 'error', response?.message
          return res.redirect contract.href()

        # refresh user balance
        req.logIn req.user, (err) ->
          res.redirect contract.href()
      error: (account, error)->
        req.flash 'error', error
        res.redirect contract.href()
  .catch next
  .done()

@tooltip = (req, res, next) ->
  status = res.locals.status
  item_id = req.query.item_id
  item_title = req.query.item_title
  contract = new Contract id: req.params.id

  contract.fetch
    success: ->
      bgColor = getColor(contract.get('gain_percent'))
      res.render 'tooltip',
        contract: contract
        bgColor: bgColor
        item_id: item_id
        item_title: item_title


