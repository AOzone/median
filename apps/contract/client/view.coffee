Backbone = require 'backbone'
Backbone.$ = $
sd = require("sharify").data
Chart = require '../../../collections/chart.coffee'
Contract = require '../../../models/contract.coffee'
{ initTickChart } = require '../../../components/tick_chart/index.coffee'
{ getColor } = require '../../../components/color/index.coffee'

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

  new ContractView
    el: $('.container--contract')
    model: contract

  chart = new Chart sd.TICK_CHART, {id: contract.id, type: '1tick'}
  initTickChart chart, $('#chart')

  $('body').css 'backgroundColor': "##{getColor(contract.get('gain_percent'))}"



