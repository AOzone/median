Backbone = require 'backbone'
mediator = require '../../../lib/mediator.coffee'
Account = require '../../../models/account.coffee'
Blocks = require '../../../collections/blocks.coffee'
transactionMap = require '../../../maps/transactions.coffee'

template = -> require('../templates/index.jade') args...

module.exports = class CallSignView extends Backbone.View
  events:
    'click .js-make-transaction' : 'triggerModal'

  initialize: ({ @model, @item }) ->
    # nothin yet

  triggerModal: (e) ->
    if @item? then @triggerConfirmModal(e) else @triggerChooseNewsModal(e)

  triggerConfirmModal: (e)->
    mediator.trigger 'confirm:trade',
      model: @model
      title: @item.get('title')
      block_id: @item.id
      transaction: $(e.currentTarget).data('transaction')
      map: transactionMap

  triggerChooseNewsModal: (e)->
    news = new Blocks sd.BLOCKS, id: @model.id

    mediator.trigger 'choose:news',
      model: @model
      blocks: news
      transaction: $(e.currentTarget).data('transaction')
      map: transactionMap

  render: ->
    @$el.html template
      contract: @model
      block_id: @item.id
      user: Account.orNull()

    this