Backbone = require 'backbone'
Account = require '../../../models/account.coffee'
CallSignView = require '../../callsign/client/index.coffee'

template = -> require('../templates/index.jade') arguments...

module.exports = class NewsListView extends Backbone.View

  initialize: ({ @collection, @contracts }) ->
    # nothin yet

  render: ->
    @$el.html template
      items: @collection
      contracts: @contracts
      user: Account.orNull()

    @postRender()

    this

  postRender: ->
    @collection.each (item) =>
      for callSign in item.callSignArray()
        itemSelector = ".news__item__callsigns[data-item_id=#{item.id}]"
        callSignSelector = ".call-sign[data-contract_id=#{callSign}]"

        contract = @contracts.findWhere({'contract': callSign})

        new CallSignView
          el: $("#{itemSelector} #{callSignSelector}")
          model: contract
          item: item

