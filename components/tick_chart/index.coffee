d3 = require 'd3'

module.exports.initTickChart = (contract) ->
  margin = {top: 20, right: 20, bottom: 30, left: 50}
  width = 960 - margin.left - margin.right
  height = 500 - margin.top - margin.bottom

  parseDate = d3.time.format("%d-%b-%y").parse

  x = d3.time.scale().range [0, width]
  y = d3.scale.linear().range [height, 0]

  xAxis = d3.svg.axis().scale(x).orient("bottom")
  yAxis = d3.svg.axis().scale(y).orient("left")

  line = d3.svg.line()
    .x((d) -> x(d.date))
    .y((d) -> y(d.close))

  svg = d3.select("#chart")
    .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(#{margin.left}, #{margin.top})")

