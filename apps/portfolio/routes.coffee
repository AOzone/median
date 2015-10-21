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

@index = (req, res, next) ->
  id = req.params.id or req.user.id

  account = new Account id: id
  account.fetch
    error: res.backboneError
    success: ->
      positions = new Positions account.get('open_positions')

      Q.allSettled(
        positions.map (position) -> position.fetch()
      ).then ->
        res.locals.sd.POSITIONS = positions.toJSON()
        res.locals.sd.ACCOUNT = account.toJSON()

        res.render 'index',
          positions: positions
          account: account
      .catch res.backboneError

@alerts = (req, res, next) ->
  id = req.params.id or req.user.id

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
      success: ->
        res.render 'alerts',
          account: account
          alerts: alerts
          numeral: numeral
          blocks: blocks
  .catch next
  .done()

