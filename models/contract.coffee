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

  formattedGain: ->
    mark = if @get('gain_percent') > 0 then "+" else ""
    "#{mark}#{numeral(@get('gain_percent')).format('0.00%')}"

  formattedPrice: (type) ->
    "#{numeral(@get(type)).format('0,0')}Å"
