Backbone = require 'backbone'
Backbone.$ = $

module.exports.OrderView = class OrderView extends Backbone.View
  events:
    'click .js-block-headline' : 'expandNews'

  expandNews: (e) ->
    e.preventDefault()
    $current = $(e.currentTarget)
    @$('.list-group-item.is-active').removeClass('is-active')
    $current.closest('.list-group-item').addClass('is-active')

module.exports.init = ->
  new OrderView
    el: $('.container--order')