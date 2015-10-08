Backbone = require 'backbone'
sd = require("sharify").data
Contract = require '../models/contract.coffee'
_ = require 'underscore'

module.exports = class Contracts extends Backbone.Collection
  model: Contract

  url: -> "#{sd.KERNAL_API_URL}/contracts"
