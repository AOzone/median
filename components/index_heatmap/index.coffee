h337 = require('../../node_modules/heatmap.js/heatmap.js')
_ = require 'underscore'
color1 = '#0AFFCD'
color2 = '#235AFF'

module.exports =
  normalizeIndexPlot: normalizeIndexPlot = (plot, scale) ->
    (scale / 4) + ((plot + 1) * scale / 4)

  initHeatmap: initHeatmap = (container_id, map, contracts) ->
    plotHeatmapKeys container_id, map

    window.onload = ->
      createHeatmap container_id, map, contracts

  plotHeatmapKeys: plotHeatmapKeys = (container_id, map) ->
    keys = _.keys _.values(map)[0]
    $("##{container_id}-key .heatmap-key__x1 h5").html keys[0]
    $("##{container_id}-key .heatmap-key__x2 h5").html keys[1]
    $("##{container_id}-key .heatmap-key__y1 h5").html keys[2]
    $("##{container_id}-key .heatmap-key__y2 h5").html keys[3]

  createHeatmap: createHeatmap = (container_id, map, contracts) ->
    heatmap = h337.create
      container: document.getElementById container_id
      gradient:
        0: color1
        1: color2
      blur: 1
      maxOpacity: 0.9

    width = (+window.getComputedStyle(document.body).width.replace(/px/,''))
    height = (+window.getComputedStyle(document.body).height.replace(/px/,''))
    plots = []

    for contractKey, plot of map
      contract = contracts.findWhere({'contract': contractKey})
      x = normalizeIndexPlot plot[_.keys(plot)[0]], width
      y = normalizeIndexPlot plot[_.keys(plot)[2]], height
      v = if contract.get('gain_percent') < 0 then 0 else contract.get('gain_percent') / 100
      r = contracts.relativeMarketCap contract
      plots.push({ x: x, y: y, value: v, radius: r * 8 })

    heatmap.setData
      max: 2
      data: plots

    $("##{container_id}").addClass('is-visible')

    window.onresize = ->
      $("##{container_id}").html ""
      createHeatmap container_id, map, contracts
