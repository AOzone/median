Backbone = require 'backbone'
sd = require("sharify").data
_ = require 'underscore'

module.exports = class Contract extends Backbone.Model
  url: ->
    "#{sd.KERNAL_API_URL}/contracts/#{@id}"

  href: ->
    "#{sd.APP_URL}/investing/futures/#{@idOrContract()}"

  idOrContract: ->
    @get('contract') or @id

  getMarketCap: ->
    parseInt(@get('market_cap')) + 1
