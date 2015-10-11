Backbone = require 'backbone'
Backbone.$ = $
sd = require("sharify").data
Chart = require '../../../collections/chart.coffee'
Contract = require '../../../models/contract.coffee'
Contracts = require '../../../collections/contracts.coffee'
Blocks = require '../../../collections/blocks.coffee'
NewsListView = require '../../../components/news_list/client/index.coffee'
{ initTickChart, updateTickChart } = require '../../../components/tick_chart/index.coffee'
{ getColor, lightOrDark } = require '../../../components/color/index.coffee'

module.exports.ContractView = class ContractView extends Backbone.View
  events:
    'click .js-block-headline' : 'expandNews'

  expandNews: (e) ->
    e.preventDefault()
    $current = $(e.currentTarget)
    @$('.list-group-item.is-active').removeClass('is-active')
    $current.closest('.list-group-item').addClass('is-active')

module.exports.init = ->
  contract = new Contract sd.CONTRACT
  contracts = new Contracts sd.ALL_CONTRACTS
  news = new Blocks sd.BLOCKS, id: contract.id

  new ContractView
    el: $('.container--contract')
    model: contract

  new NewsListView(
    el: $('section.contract__news')
    collection: news
    contracts: contracts
  ).postRender()

  chart = new Chart sd.TICK_CHART, {id: contract.id, type: '1tick'}
  initTickChart chart, $('#chart')

  $(window).on 'resize', -> updateTickChart chart, $('#chart')

  $('main').css 'backgroundColor': "##{getColor(contract.get('gain_percent'))}"