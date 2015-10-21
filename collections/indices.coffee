Backbone = require 'backbone'
sd = require("sharify").data
_ = require 'underscore'

module.exports = class Indices extends Backbone.Collection
  url: -> "#{sd.KERNAL_API_URL}/indices"

  statement: ->
    coin = if Math.random() < 0.5 then 1 else 2
    index = @shuffle()[0]
    console.log 'index', index, coin, index.get("pp_gain#{coin}")
    index.get("pp_gain#{coin}")
