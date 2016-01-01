Q = require 'bluebird-q'
_ = require 'underscore'
Qs = require 'qs'
Backbone = require "backbone"
numeral = require 'numeral'
sd = require("sharify").data
Account = require '../../models/account.coffee'
Alerts = require '../../models/alerts.coffee'
Blocks = require '../../collections/blocks.coffee'
Positions = require '../../collections/positions.coffee'
Contracts = require '../../collections/contracts.coffee'

@index = (req, res, next) ->
  id = req.params.id or req.user?.id
  account = new Account id: id
  contracts = new Contracts []

  Q.all [
    account.fetch()
    contracts.fetch()
  ]
  .then ->
    positions = new Positions account.get('open_positions')
    positions.each (position) ->
      contract = contracts.findWhere({contract: position.get('contract')})
      position.set(contract.attributes) if contract

    res.locals.sd.POSITIONS = positions.toJSON()
    res.locals.sd.ACCOUNT = account.toJSON()

    res.render 'index',
      positions: positions
      account: account
  .catch next
  .done()

@alerts = (req, res, next) ->
  id = req.params.id or req.user?.id

  account = new Account id: id
  alerts = new Alerts user_id: id
  blocks = new Blocks [], id: null
  blocks.url = "#{sd.ARENA_API_URL}/blocks/multi"

  Q.all [
    account.fetch()
    alerts.fetch()
  ]
  .then ->
    blocks.fetch
      data: Qs.stringify { block_ids: alerts.allBlockIds() }, arrayFormat: 'brackets'
      cache: true
      success: ->
        res.render 'alerts',
          account: account
          alerts: alerts
          numeral: numeral
          blocks: blocks
  .catch next
  .done()

@goods = (req, res, next) ->
  id = req.params.id or req.user?.id

  account = new Account id: id

  Q.all [
    account.fetch()
  ]
  .then ->
    User.findOne { 'username' :  id }, (err, user) ->
      if err
        console.log "Error: " + err
        return false

      # Username does not exist, log the error and redirect back
      unless user
        console.log "User Not Found with username: #{username} "
        return false

      res.render 'goods',
        account: account
        goods: user.goods
        numeral: numeral
  .catch next
  .done()
