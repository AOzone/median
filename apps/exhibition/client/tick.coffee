Backbone = require 'backbone'
Backbone.$ = $
sd = require("sharify").data
Chart = require '../../../collections/chart.coffee'
Contract = require '../../../models/contract.coffee'
{ initTickChart, updateTickChart } = require '../../../components/tick_chart/index.coffee'

module.exports.initTick = ->
  contract = new Contract sd.CONTRACT
  chart = new Chart sd.TICK_CHART, {id: contract.id, type: '1tick'}

  # tick chart
  initTickChart chart, $('#chart')
  $(window).on 'resize', -> updateTickChart chart, $('#chart'), 10
