Backbone = require 'backbone'
sd = require("sharify").data
_ = require 'underscore'

module.exports = class Balance extends Backbone.Model

  url: ->
    "#{sd.KERNAL_API_URL}/positions?trader_id=#{@id}"

