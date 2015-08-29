Backbone = require 'backbone'
sd = require("sharify").data
_ = require 'underscore'

module.exports = class Contract extends Backbone.Model

  urlRoot: -> "#{sd.KERNAL_API_URL}/quote?contract=#{@id}"
