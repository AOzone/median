Q = require 'bluebird-q'
_ = require 'underscore'
Backbone = require "backbone"
sd = require("sharify").data
Account = require '../../models/account.coffee'
Positions = require '../../collections/positions.coffee'

@index = (req, res, next) ->
  id = req.params.id or req.user.id

  account = new Account id: id
  account.fetch
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
