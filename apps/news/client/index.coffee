NewsListView = require '../../../components/news_list/client/index.coffee'
sd = require("sharify").data
Blocks = require '../../../collections/blocks.coffee'
Contracts = require '../../../collections/contracts.coffee'

module.exports.initNews = ->
  contracts = new Contracts sd.ALL_CONTRACTS
  news = new Blocks sd.BLOCKS, id: null
