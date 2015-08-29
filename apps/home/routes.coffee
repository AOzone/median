Q = require 'q'
_ = require 'underscore'
Backbone = require "backbone"
sd = require("sharify").data
Contracts = require '../../collections/contracts.coffee'

@index = (req, res, next) ->
  contracts = new Contracts
  contracts.fetch
    success: ->
      res.locals.sd.CONTRACTS = contracts
      res.render 'index',
        contracts: contracts.models
        message: req.flash 'message'
    error: (err, contracts) ->
      console.log 'error requesting contracts', err, contracts
