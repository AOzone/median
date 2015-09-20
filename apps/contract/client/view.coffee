Backbone = require 'backbone'
Backbone.$ = $
sd = require("sharify").data
Chart = require '../../../collections/chart.coffee'
{ initTickChart } = require '../../../components/tick_chart/index.coffee'

module.exports.ContractView = class ContractView extends Backbone.View
  events:
    'click .js-block-headline' : 'expandNews'

  expandNews: (e) ->
    e.preventDefault()
    $current = $(e.currentTarget)
    @$('.list-group-item.is-active').removeClass('is-active')
    $current.closest('.list-group-item').addClass('is-active')

module.exports.init = ->
  new ContractView
    el: $('.container--contract')

  chart = new Chart sd.TICK_CHART, {id: sd.CONTRACT.id, type: '1tick'}
  initTickChart chart, $('#chart')


