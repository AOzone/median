sd = require("sharify").data
_ = require 'underscore'
{ initHeatmap } = require '../../../components/index_heatmap/index.coffee'
NewsListView = require '../../../components/news_list/client/index.coffee'
Blocks = require '../../../collections/blocks.coffee'
Contracts = require '../../../collections/contracts.coffee'
map = require '../../../maps/indices/basic.coffee'
spinningGlobe = require './components/spinning_globe/index.js'
{ initTreeMap, updateTreeMap } = require '../../../components/portfolio_treemap/index.coffee'

module.exports.init = ->
  contracts = new Contracts sd.CONTRACTS
  initHeatmap 'index-heatmap', map, contracts

  positions = { children:  _.last (_.shuffle sd.CONTRACTS), 8 }
  initTreeMap positions, $('#future-treemap')
  $(window).on 'resize', -> updateTreeMap positions, $('#future-treemap')

  $('#about__spinning-globe-future-list h3:gt(0)').hide()

  setInterval ->
    $('#about__spinning-globe-future-list :first-child').fadeOut(2000)
       .next('h3').fadeIn(4000)
       .end().appendTo('#about__spinning-globe-future-list')

  , 6000
