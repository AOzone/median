Backbone = require 'backbone'
Backbone.$ = $
sd = require("sharify").data
Chart = require '../../../collections/chart.coffee'
Contract = require '../../../models/contract.coffee'
Contracts = require '../../../collections/contracts.coffee'
Blocks = require '../../../collections/blocks.coffee'
NewsListView = require '../../../components/news_list/client/index.coffee'
CallSignView = require '../../../components/callsign/client/index.coffee'
modalize = require '../../../components/modalize/index.coffee'
{ initTickChart, updateTickChart } = require '../../../components/tick_chart/index.coffee'
{ getColor } = require '../../../components/color/index.coffee'

template = -> require('../templates/tip.jade') arguments...

module.exports = class TipView extends Backbone.View

  initialize: ({@item, @transactions}) ->
    # no op

  render: =>
    @$el.html template
      item: @item
      transactions: @transactions

    return this


module.exports = class ContractRouter extends Backbone.Router
  routes:
    'tip/:id': 'showTip'

  initialize: ({ @news, @chart }) ->
    # no op

  showTip: (id) ->
    item = @news.get(id)
    transactions = @chart.where block_id: id

    view = new TipView
      item: item
      transactions: transactions

    modal = modalize view, className: 'modalize modalize--gray'
    modal.open()


module.exports.init = ->
  contract = new Contract sd.CONTRACT
  contracts = new Contracts sd.ALL_CONTRACTS
  news = new Blocks sd.BLOCKS, id: contract.id
  chart = new Chart sd.TICK_CHART, {id: contract.id, type: '1tick'}

  # tip router
  router = new ContractRouter
    news: news
    chart: chart

  Backbone.history.start()

  # handle news clicks
  $('body').on 'click', '.news__item', (e)->
    router.navigate "tip/#{$(e.currentTarget.data('block_id'))}", trigger: true

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
