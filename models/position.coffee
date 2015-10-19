Contract = require './contract.coffee'
sd = require("sharify").data
_ = require 'underscore'
numeral = require 'numeral'

module.exports = class Position extends Contract
  idAttribute: "contract"

  url: ->
    "#{sd.KERNAL_API_URL}/contracts/#{@id}"

  formattedGain: (attr = 'gain_percent')->
    gain = @get(attr) / 100
    mark = if gain > 0 then "+" else ""
    "#{mark}#{numeral(gain).format('0.00%')}"
