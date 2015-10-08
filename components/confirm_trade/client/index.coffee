Backbone = require 'backbone'
modalize = require '../../modalize/index.coffee'
mediator = require '../../../lib/mediator.coffee'

template = -> require('../templates/index.jade') arguments...

module.exports.ConfirmTradeView = class ConfirmTradeView extends Backbone.View

  initialize: ({ @model, @title, @block_id }) ->
    # nothin yet

  render: ->
    console.log 'model'
    @$el.html template
      contract: @model
      title: @title
      block_id: @block_id

    this

module.exports.initConfirmTrade = ->
  mediator.on 'confirm:trade', (options) ->
    view = new ConfirmTradeView options
    modal = modalize view
    modal.open()