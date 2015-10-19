Positions = require '../../../collections/positions.coffee'
{ initTreeMap, updateTreeMap } = require '../../../components/portfolio_treemap/index.coffee'

module.exports =
  initPortfolio: ->
    positions = { children: sd.POSITIONS }
    initTreeMap positions, $('#portfolio-treemap')
    $(window).on 'resize', -> updateTreeMap positions, $('#portfolio-treemap')

