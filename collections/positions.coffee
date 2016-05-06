Backbone = require 'backbone'
sd = require("sharify").data
_ = require 'underscore'
Position = require '../models/position.coffee'

module.exports = class Positions extends Backbone.Collection

  model: Position

  totalPercentageGain: ->
    value = @reduce (memo, position) ->
      memo + parseFloat(position.gainOrLoss())
    , 0

    value.toFixed(2)

  totalMarketValue: ->
    @reduce (memo, position) ->
      memo + position.value()
    , 0
