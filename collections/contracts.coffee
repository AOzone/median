Backbone = require 'backbone'
sd = require("sharify").data
_ = require 'underscore'

module.exports = class Contracts extends Backbone.Collection

  url: -> "#{sd.KERNAL_API_URL}/contracts"
