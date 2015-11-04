d3 = require 'd3'
{ getColor } = require '../color/index.coffee'

module.exports =
  initFundBubbles: initFundBubbles = (positions, $container) ->
    container_id = $container.attr('id')
    diameter = $container.width()
    format = d3.format(",d")

    console.log 'diameter', diameter

    bubble = d3.layout.pack()
      .sort(null)
      .size([diameter, diameter])
      .padding(12.5)
      .value((d) ->
        d.current_value || d.market_cap
      )

    svg = d3.select("##{container_id}").append("svg")
      .attr("width", diameter)
      .attr("height", diameter)
      .attr("class", "bubble")

    node = svg.selectAll(".node")
      .data(bubble.nodes(positions))
      .enter().append("g")
      .attr("class", "node")
      .attr("transform", (d)  ->
        "translate(" + d.x + "," + d.y + ")"
      )

    node.append("circle")
      .attr("r", (d) -> d.r )
      .style("fill", (d) ->
        if d.gain_percent
          return "##{getColor(d.gain_percent)}"
        else
          return "rgb(19, 155, 226)"
      )
      .style("stroke-width", (d) ->
        if d.gain_percent
          return 1
        else
          return 0
      )
      .style("stroke", "#fff")

    node.append("text")
      .attr("dy", ".3em")
      .style("text-anchor", "middle")
      .text((d) ->
        d.contract?.substring(0, d.r / 3)
      )

  updateFundBubbles: updateFundBubbles = (positions, $container) ->
    container_id = $container.attr('id')
    d3.select("##{container_id} > svg").remove()
    initFundBubbles positions, $container
