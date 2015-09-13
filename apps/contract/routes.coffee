Q = require 'q'
_ = require 'underscore'
Backbone = require "backbone"
sd = require("sharify").data
Contract = require '../../models/contract.coffee'
Blocks = require '../../collections/blocks.coffee'
contractMap = require '../../maps/contracts.coffee'
transactionMap = require '../../maps/transactions.coffee'

fetchContract = (callSign, next, cb)->
  dfd = Q.defer()
  channelId = contractMap[callSign]?.channel_id

  return dfd.reject(message: 'Channel not found') unless channelId

  contract = new Contract id: callSign
  blocks = new Blocks [], id: channelId

  Q.all([
    contract.fetch()
    blocks.fetch(cache: true)
  ]).then ->
    # set any additional metadata
    contract.set contractMap[callSign]

    dfd.resolve
      contract: contract
      blocks: blocks
  .catch (err, message) ->
    dfd.reject err, message
  .done()

  dfd.promise
@show = (req, res, next) ->
  callSign = req.params.id
  fetchContract(callSign, next).then ({ contract, blocks }) ->

    res.render 'contract',
      blocks: blocks.models
      contract: contract
      message: req.flash 'error'

  .done()

@order = (req, res, next) ->
  return next() unless req.user
  transaction = req.params.transaction
  callSign = req.params.id
  fetchContract(callSign, next).then ({ contract, blocks }) ->

    { success, reason } = req.user.canMakeTransaction transaction, contract
    unless success
      req.flash 'error', reason
      return res.redirect "/contract/#{contract.id}"

    res.render 'order',
      blocks: blocks.models
      contract: contract
      transaction: transaction
      price: contract.get transactionMap[transaction]

  .done()

@transaction = (req, res, next) ->
  return next() unless req.user
  transaction = req.params.transaction
  callSign = req.params.id
  fetchContract(callSign, next).then ({ contract, blocks }) ->

    { success, reason } = req.user.canMakeTransaction transaction, contract
    unless success
      req.flash 'error', reason
      return res.redirect "/contract/#{contract.id}"

    console.log 'transaction', transaction

    req.user.makeTransaction { transaction: transaction, contract: contract },
      success: ->
        # refresh user balance
        req.logIn req.user, (err) ->
          res.redirect "/contract/#{contract.id}"
      error: (account, error)->
        req.flash 'error', error
        res.redirect "/contract/#{contract.id}"

  .done()



