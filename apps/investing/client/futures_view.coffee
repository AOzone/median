Backbone = require 'backbone'
Backbone.$ = $
sd = require("sharify").data
Contracts = require '../../../collections/contracts.coffee'
{ getColor, lightOrDark } = require '../../../components/color/index.coffee'

module.exports.init = ->
  contracts = new Contracts sd.CONTRACTS

  contracts.each (contract) ->
    mc = contracts.relativeMarketCap contract
    $("#contract_#{contract.get('contract')} .future-circle__circle").css
      width: "#{mc}%"
      paddingTop: "#{mc}%"