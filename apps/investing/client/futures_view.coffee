Backbone = require 'backbone'
Backbone.$ = $
sd = require("sharify").data
Contracts = require '../../../collections/contracts.coffee'
{ getColor, lightOrDark } = require '../../../components/color/index.coffee'

module.exports.init = ->
  contracts = new Contracts sd.CONTRACTS

  contracts.each (contract) ->
    mc = Math.min((contract.get('radius') * 100), 80)

    $("#contract_#{contract.get('contract')} .future-circle__circle").css
      width: "#{mc}%"
      paddingTop: "#{mc}%"
