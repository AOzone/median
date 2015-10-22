sd = require("sharify").data
_ = require 'underscore'
{ initHeatmap } = require '../../../components/index_heatmap/index.coffee'
Contracts = require '../../../collections/contracts.coffee'
map = require '../../../maps/indices/basic.coffee'

module.exports.initIndex = ->
  contracts = new Contracts sd.CONTRACTS
  initHeatmap 'index-heatmap', map, contracts
