Backbone = require 'backbone'
mediator = require '../../../lib/mediator.coffee'
Account = require '../../../models/account.coffee'

template = -> require('../templates/index.jade') args...

module.exports = class CallSignView extends Backbone.View
  events:
    'click .js-make-transaction' : 'triggerConfirmModal'

  initialize: ({ @model, @item }) ->
    console.log 'model', @model
    # nothin yet

  triggerConfirmModal: ->
    if @item?
      mediator.trigger 'confirm:trade',
        model: @model
        title: @item.get('title')
        block_id: @item.id

  render: ->
    @$el.html template
      contract: @model
      block_id: @item.id
      user: Account.orNull()

    this