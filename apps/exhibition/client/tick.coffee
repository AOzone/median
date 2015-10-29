_ = require 'underscore'
sd = require("sharify").data
Chart = require '../../../collections/chart.coffee'
Contract = require '../../../models/contract.coffee'
{ initTickChart, updateTickChart } = require '../../../components/tick_chart/index.coffee'

module.exports.initTick = ->
  contract = new Contract sd.CONTRACT
  chart = new Chart sd.TICK_CHART, {id: contract.id, type: '1tick'}

  # tick chart
  { svg, d3, height, width } = initTickChart chart, $('#chart'), 10

  # svg.append('line')
  #   .attr('id', 'focusLineX')
  #   .attr('class', 'focusLine')
  #   .attr('x1', 0)
  #   .attr('x2', 0)
  #   .attr('y1', 0)
  #   .attr('y2', height)

  # _.defer => $("#focusLineX").attr 'class', 'focusLine animated'
