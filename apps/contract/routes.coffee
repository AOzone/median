Q = require 'q'
_ = require 'underscore'
Backbone = require "backbone"
sd = require("sharify").data
Contract = require '../../models/contract.coffee'
Blocks = require '../../collections/blocks.coffee'
contractMap = require '../../maps/contracts.coffee'

@show = (req, res, next) ->
  callSign = req.params.id
  channelId = contractMap[callSign]?.channel_id

  return next() unless channelId

  contract = new Contract id: callSign
  blocks = new Blocks [], id: channelId

  Q.all([
    contract.fetch()
    blocks.fetch(cache: true)
  ]).then ->
    console.log 'contract', contract
    contract.set contractMap[callSign]
    res.render 'contract',
      blocks: blocks.models
      contract: contract
  .catch (err, message)->
    console.log 'error fetching stuff', err, message
    next()
  .done()


