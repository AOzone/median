Q = require 'bluebird-q'
_ = require 'underscore'
Backbone = require "backbone"
sd = require("sharify").data
Contracts = require '../../collections/contracts.coffee'

@futures = (req, res, next) ->
  contracts = new Contracts
  contracts.fetch
    success: ->
      res.locals.sd.CONTRACTS = contracts
      tab = res.locals.sd.TAB = 'futures'
      res.render 'futures',
        contracts: contracts
        tab: tab
        message: req.flash 'message'
    error: (err, contracts) ->
      console.log 'error requesting contracts', err, contracts

@funds = (req, res, next) ->
  contracts = new Contracts
  contracts.fetch
    success: ->
      res.locals.sd.CONTRACTS = contracts
      tab = res.locals.sd.TAB = 'funds'
      res.render 'futures',
        contracts: contracts.models
        tab: tab
        message: req.flash 'message'
    error: (err, contracts) ->
      console.log 'error requesting contracts', err, contracts

@indices = (req, res, next) ->
  contracts = new Contracts
  contracts.fetch
    success: ->
      res.locals.sd.CONTRACTS = contracts
      tab = res.locals.sd.TAB = 'indices'
      res.render 'futures',
        contracts: contracts.models
        tab: tab
        message: req.flash 'message'
    error: (err, contracts) ->
      console.log 'error requesting contracts', err, contracts
