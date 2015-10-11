Backbone = require 'backbone'
modalize = require '../../modalize/index.coffee'
mediator = require '../../../lib/mediator.coffee'
transactionMap = require '../../../maps/transactions.coffee'

template = -> require('../templates/index.jade') arguments...

module.exports.ChooseNewsView = class ChooseNewsView extends Backbone.View
  className: 'v-outer'

  events:
    'click .news____grid-item' : 'selectOrCreateNews'

  initialize: ({ @model, @blocks, @transaction }) ->
    # nothin yet

  selectOrCreateNews: (e) ->
    console.log "$(e.currentTarget).data('title')", $(e.currentTarget).data('title')
    console.log "$(e.currentTarget).data('id')", $(e.currentTarget).data('id')
    mediator.trigger 'confirm:trade',
      model: @model
      title: $(e.currentTarget).data('title')
      block_id: $(e.currentTarget).data('id')
      transaction: @transaction
      map: transactionMap

    @trigger 'close'

  render: =>
    @$el.html template
      news: @blocks
      contract: @model
      transaction: @transaction

    return this

module.exports.initChooseNews = ->
  mediator.on 'choose:news', (options) ->
    view = new ChooseNewsView options
    modal = modalize view
    modal.open()