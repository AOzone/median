d3 = require 'd3'

module.exports =
  initTickChart: initTickChart = (chart, $container) ->
    width = $container.width()
    height = 260
    margin = {top: 20, right: 20, bottom: 30, left: 50}

    x = d3.scale.linear().range [0, width - 52]
    y = d3.scale.linear().range [height, 0]

    xAxis = d3.svg.axis().scale(x).orient("bottom")
    yAxis = d3.svg.axis().scale(y).orient("left")

    line = d3.svg.line()
      .x((point, index) -> x(index))
      .y((point) -> y(parseInt(point.get('close'))))

    svg = d3.select("#chart")
      .append("svg")
      .attr("width", $container.width())
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(#{margin.left}, #{margin.top})")

    x.domain d3.extent chart.models, (point, index) -> index
    y.domain d3.extent chart.models, (point) -> parseInt(point.get('close'))

    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis)

    svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)
      .append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 6)
        .attr("dy", ".71em")
        .style("text-anchor", "end")
        .text("Å")

    svg.append("path")
        .datum(chart.models)
        .attr("class", "line")
        .attr("d", line)

  updateTickChart: updateTickChart = (chart, container) ->
    d3.select("#chart svg").remove()
    initTickChart chart, container