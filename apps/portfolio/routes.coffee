Q = require 'bluebird-q'
_ = require 'underscore'
Backbone = require "backbone"
sd = require("sharify").data
Account = require '../../models/account.coffee'
Positions = require '../../collections/positions.coffee'

renderPortfolio = (positions, req, res, next) ->
  positions = new Positions positions, parse: true

  Q.allSettled(
    positions.map (position) -> position.fetch()
  ).then ->
    res.render 'index',
      positions: positions
  .catch (error) ->
    console.log 'error', error
    next()
  .done()

@index = (req, res, next) ->
  return unless req.user

  if req.params.id
    account = new Account id: req.params.id
    account.fetch
      success: ->
        renderPortfolio account.get('open_positions'), req, res, next
  else
    renderPortfolio req.user.get('open_positions'), req, res, next
