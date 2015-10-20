Backbone = require 'backbone'
sd = require("sharify").data
_ = require 'underscore'
numeral = require 'numeral'

module.exports = class Contract extends Backbone.Model
  url: ->
    "#{sd.KERNAL_API_URL}/contracts/#{@id}"

  href: ->
    "#{sd.APP_URL}/investing/futures/#{@idOrContract()}"

  idOrContract: ->
    @get('contract') or @id

  getMarketCap: ->
    parseInt(@get('market_cap')) + 1

  formattedGain: (attr = 'gain_percent')->
    mark = if @get(attr) > 0 then "+" else ""
    "#{mark}#{@get(attr)}%"

  formattedPrice: (type) ->
    "#{numeral(@get(type)).format('0,0')}Å"
