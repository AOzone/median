Backbone = require 'backbone'
sd = require("sharify").data
_ = require 'underscore'

module.exports = class Account extends Backbone.Model

  url: ->
    "#{sd.KERNAL_API_URL}/create-account?trader_id=#{@id}&opening_credit=#{sd.OPENING_CREDITS}"

