sd = require("sharify").data
{ initHeatmap } = require '../../../components/index_heatmap/index.coffee'
NewsListView = require '../../../components/news_list/client/index.coffee'
Blocks = require '../../../collections/blocks.coffee'
Contracts = require '../../../collections/contracts.coffee'
map = require '../../../maps/indices/basic.coffee'
spinningGlobe = require './components/spinning_globe/index.js'

module.exports.init = ->
  contracts = new Contracts sd.CONTRACTS
  initHeatmap 'index-heatmap', map, contracts

  news = new Blocks sd.BLOCKS, id: null
  new NewsListView(
    el: $('section.news')
    collection: news
    contracts: contracts
  ).postRender()


  # spinning globe
  spinningGlobe 'about__spinning-globe'

  $('#about__spinning-globe-future-list h3:gt(0)').hide()

  setInterval ->
    $('#about__spinning-globe-future-list :first-child').fadeOut(2000)
       .next('h3').fadeIn(4000)
       .end().appendTo('#about__spinning-globe-future-list')

  , 6000

  $('#about__spinning-globe').height $('#about__spinning-globe').width() / 3
  $(window).resize ->
    $('#about__spinning-globe').height $('#about__spinning-globe').width() / 3
