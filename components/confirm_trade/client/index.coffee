Backbone = require 'backbone'
modalize = require '../../modalize/index.coffee'
mediator = require '../../../lib/mediator.coffee'

template = -> require('../templates/index.jade') arguments...

module.exports.ConfirmTradeView = class ConfirmTradeView extends Backbone.View
  className: 'v-outer'

  events:
    'click .button--modal' : 'disableButton'

  initialize: ({ @model, @title, @block_id, @transaction }) ->
    # nothin yet

  disableButton: ->
    @$('.button--modal').prop "disabled",true
    @$('form').submit()

  render: =>
    @$el.html template
      contract: @model
      title: @title
      block_id: @block_id
      transaction: @transaction

    return this

module.exports.initConfirmTrade = ->
  mediator.on 'confirm:trade', (options) ->
    view = new ConfirmTradeView options
    modal = modalize view
    modal.open()
