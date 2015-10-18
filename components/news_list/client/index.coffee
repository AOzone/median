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

    this
