Positions = require '../../../collections/positions.coffee'
{ initFundBubbles, updateFundBubbles } = require '../../../components/fund_bubble_chart/index.coffee'

module.exports =
  init: ->
    positions = { children: sd.POSITIONS }
    initFundBubbles positions, $('#fund-circles')
    $(window).on 'resize', -> updateFundBubbles positions, $('#fund-circles')

