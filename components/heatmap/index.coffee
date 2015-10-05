h337 = require('../../node_modules/heatmap.js/heatmap.js')
color1 = '#0AFFCD'
color2 = '#235AFF'

module.exports =
  init: (container_id)->
    window.onload = ->
      heatmap = h337.create
        container: document.getElementById container_id
        gradient:
          0.1: '#0AFFCD'
          0.95: '#235AFF'
        maxOpacity: 1
        radius: 20
        blur: .99

      width = (+window.getComputedStyle(document.body).width.replace(/px/,''))
      height = (+window.getComputedStyle(document.body).height.replace(/px/,''))

      extremas = [(Math.random() * 1000) >> 0,(Math.random() * 1000) >> 0]
      max = Math.max.apply(Math, extremas)
      min = Math.min.apply(Math, extremas)
      t = []

      for filename in [1..900]
        x = (Math.random() * (width / 2)) >> 0
        y = (Math.random() * (height/ 2)) >> 0
        c = ((Math.random() * max-min) >> 0) + min
        r = (Math.random() * 100) >> 0
        t.push({ x: x * 2, y: y * 2, value: c, radius: r })

      heatmap.setData
        min: min
        max: max
        data: t