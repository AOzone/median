sd = require("sharify").data
_ = require 'underscore'
Contracts = require '../../../collections/contracts.coffee'

module.exports.initFutures = ->
  contracts = new Contracts sd.CONTRACTS

  contracts.each (contract) ->
    mc = Math.min(contracts.relativeMarketCap(contract) * 2, 70)

    $("#contract_#{contract.get('contract')} .future-circle__circle").css
      width: "#{mc}%"
      paddingTop: "#{mc}%"
