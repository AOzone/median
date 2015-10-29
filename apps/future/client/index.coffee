Backbone = require 'backbone'
Backbone.$ = $
sd = require("sharify").data
Chart = require '../../../collections/chart.coffee'
Contract = require '../../../models/contract.coffee'
Contracts = require '../../../collections/contracts.coffee'
Transactions = require '../../../collections/transactions.coffee'
Blocks = require '../../../collections/blocks.coffee'
NewsListView = require '../../../components/news_list/client/index.coffee'
CallSignView = require '../../../components/callsign/client/index.coffee'
modalize = require '../../../components/modalize/index.coffee'
{ initTickChart, updateTickChart } = require '../../../components/tick_chart/index.coffee'
{ getColor } = require '../../../components/color/index.coffee'

template = -> require('../templates/tip.jade') arguments...
transactionTemplate = -> require('../templates/transaction_list.jade') arguments...

module.exports = class TipView extends Backbone.View

  initialize: ({@item, @contracts}) ->
    @collection.on 'sync', @renderTransactions, @

  render: =>
    @$el.html template
      item: @item
      contracts: @contracts

    @postRender()

    return this

  postRender: ->
    @collection.url = "#{sd.APP_URL}/transactions/#{@item.id}"
    @collection.fetch()

  renderTransactions: ->
    @$('.tip-transactions').html transactionTemplate transactions: @collection.models, contracts: @contracts


module.exports = class ContractRouter extends Backbone.Router
  routes:
    '': 'closeTip'
    'tip/:id': 'showTip'

  initialize: ({ @news, @chart, @contracts }) ->
    # no op

  closeTip: ->
    @modal?.close()

  showTip: (id) ->
    item = @news.get(id)
    tips = new Transactions [], id: id

    view = new TipView
      item: item
      contracts: @contracts
      collection: tips

    @modal = modalize view, className: 'modalize modalize--gray'
    @modal.open()

module.exports.init = ->
  contract = new Contract sd.CONTRACT
  contracts = new Contracts sd.ALL_CONTRACTS
  news = new Blocks sd.BLOCKS, id: contract.id
  chart = new Chart sd.TICK_CHART, {id: contract.id, type: '1tick'}

  # tip router
  router = new ContractRouter
    news: news
    chart: chart
    contracts: contracts

  Backbone.history.start()

  # tick chart
  initTickChart chart, $('#chart')
  $(window).on 'resize', -> updateTickChart chart, $('#chart')

  sticky = new Waypoint.Sticky
    element: $('.contract__tick-chart')[0]

  $('.news__item').waypoint
    offset: ->
      $('.contract__tick-chart').outerHeight() + $('nav').outerHeight() + 100
    handler: (direction)->
      $('circle').hide()
      block_id = $(this.element).data('block-id')
      $("circle[data-block-id=#{block_id}]").show()

  $('.contract__tick-chart').css 'backgroundColor': "##{getColor(contract.get('gain_percent'))}"
