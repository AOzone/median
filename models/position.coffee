Backbone = require 'backbone'
sd = require("sharify").data
_ = require 'underscore'

module.exports = class Positions extends Backbone.Model
  idAttribute: "contract"

  url: ->
    "#{sd.KERNAL_API_URL}/contracts/#{@id}"

  gainOrLoss: ->
    price = parseInt(@get('bid'))
    purchased = parseInt(@get('avg_price'))
    gain = price - purchased

    ((gain / purchased) * 100).toFixed(2)

  value: ->
    price = parseInt(@get('bid'))
    qty = parseInt(@get('qty'))

    price * qty
