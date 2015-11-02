d3 = require 'd3'

module.exports =
  initTickChart: initTickChart = (chart, $container, tickNum = null) ->
    width = $container.width()
    height = $container.height()
    margin = {top: 40, right: 0, bottom: 30, left: 50}
    tickCount = tickNum || parseInt(height/25)

    x = d3.scale.linear().range [0, width - 52]
    y = d3.scale.linear().range [height, 0]

    xAxis = d3.svg.axis().scale(x).orient("bottom")
    yAxis = d3.svg.axis()
      .scale(y)
      .orient("left")
      .innerTickSize(-width)
      .tickFormat((d) -> "#{d}Å")
      .tickPadding(10)
      .ticks(tickCount)

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
      .attr("transform", "translate(-10,0)")
      .attr("y", 6)
      .attr("dy", ".71em")

    svg.append("path")
      .datum(chart.models)
      .attr("class", "line")
      .attr("d", line)

    svg.selectAll("circle")
      .data(chart.models)
      .enter().append("circle")
      .attr("r", 6)
      .attr("cx", (d, index) -> x(index) )
      .attr("cy", (d, index) -> y(d.get('close')) )
      .attr("data-block-id", (d, index) -> d.get('block_id'))

    { svg: svg, d3: d3, width: width, height: height }

  updateTickChart: updateTickChart = (chart, container) ->
    d3.select("#chart svg").remove()
    initTickChart chart, container
