{ CAPTCHA_KEY } = require('sharify').data
_ = require 'underscore'
Backbone = require 'backbone'
modalize = require '../../modalize/index.coffee'
mediator = require '../../../lib/mediator.coffee'
transactionMap = require '../../../maps/transactions.coffee'

template = -> require('../templates/index.jade') arguments...

module.exports.ConfirmTradeView = class ConfirmTradeView extends Backbone.View
  className: 'v-outer'

  events:
    'click .button--modal' : 'disableButton'

  initialize: ({ @model, @title, @block_id, @transaction, @is_new}) ->
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
      map: transactionMap
      is_new: @is_new

    _.defer => @postRender()

    return this

  postRender: ->
    grecaptcha.render 'recaptcha',
      sitekey: CAPTCHA_KEY
      theme: 'dark'
      callback: =>
        @$('.button--modal').attr 'disabled', false
      'expired-callback': =>
        @$('.button--modal').attr 'disabled', true

module.exports.initConfirmTrade = ->
  mediator.on 'confirm:trade', (options) ->
    view = new ConfirmTradeView options
    modal = modalize view
    modal.open()
