d3 = require 'd3'
Contract = require '../../models/contract.coffee'
numeral = require 'numeral'
{ getColor } = require '../color/index.coffee'

template = -> require('./node.jade') arguments...

module.exports =
  initTreeMap: initTreeMap = (positions, $container) ->
    container_id = $container.attr('id')
    width = $container.width()
    height = $container.height()

    treemap = d3.layout.treemap()
      .size([width, height])
      .sticky(true)
      .value((d) -> d.current_value || d.market_cap )

    div = d3.select("##{container_id}").append("div")
      .style("position", "relative")
      .style("width", width + "px")
      .style("height", height + "px")

    node = div.datum(positions).selectAll(".node")
      .data(treemap.nodes)
      .enter().append("div")
      .attr("class", "node")
      .call(treePosition)
      .style("background", (d) -> "##{getColor(d.gain_percent)}")
      .html((d) ->
        template contract: new Contract(d), numeral: numeral
      )

  treePosition: treePosition = ->
    this.style("left", (d) ->  d.x + "px")
      .style("top", (d) -> d.y + "px")
      .style("width", (d) -> Math.max(0, d.dx - 1) + "px" )
      .style("height", (d) -> Math.max(0, d.dy - 1) + "px")

  updateTreeMap: updateTreeMap = (positions, $container) ->
    container_id = $container.attr('id')
    d3.select("##{container_id} > div").remove()
    initTreeMap positions, $container
