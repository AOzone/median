Contract = require './contract.coffee'
sd = require("sharify").data
_ = require 'underscore'

module.exports = class Positions extends Contract
  idAttribute: "contract"

  url: ->
    "#{sd.KERNAL_API_URL}/contracts/#{@id}"
