sd = require("sharify").data
{ initHeatmap } = require '../../../components/index_heatmap/index.coffee'
NewsListView = require '../../../components/news_list/client/index.coffee'
Blocks = require '../../../collections/blocks.coffee'
Contracts = require '../../../collections/contracts.coffee'
map = require '../../../maps/indices/basic.coffee'

module.exports.init = ->
  contracts = new Contracts sd.CONTRACTS
  initHeatmap 'index-heatmap', map, contracts

  news = new Blocks sd.BLOCKS, id: null
  new NewsListView(
    el: $('section.news')
    collection: news
    contracts: contracts
  ).postRender()