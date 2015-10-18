Backbone = require 'backbone'
{ KERNAL_API_URL } = require '../config.coffee'
transactionMap = require '../maps/transactions.coffee'
{ authTokenPair } = require '../lib/util/token.coffee'
numeral = require 'numeral'
_ = require 'underscore'

module.exports = class Account extends Backbone.Model

  url: -> "#{KERNAL_API_URL}/accounts/#{@idOr_id()}"

  sync: (method, model, options = {})->
    { authId, authToken } = authTokenPair()
    options.data ?= {}
    options.data = _.extend options.data, { auth_id: authId, auth_token: authToken }
    super

  idOr_id: ->
    @id or @get('_id')

  orNull: ->
    if sd.CURRENT_USER then new @(sd.CURRENT_USER) else null

  formatBalance: ->
    "#{numeral(@get('balance')).format('0,0')}Å"

  holdsPosition: (contract) ->
    _.any @get('open_positions'), (position) ->
      position.contract is contract.get('contract')

  makeTransaction: ({ transaction, contract, block_id, is_new, comment }, options) ->
    { authId, authToken } = authTokenPair()
    order = new Backbone.Model
    params = "?auth_id=#{authId}&auth_token=#{authToken}"

    flag = if is_new then "*" else ""
    order.url = "#{@url()}/#{transaction}/#{contract.id}/block_id/#{flag}#{block_id}#{params}"

    options.data = "comment=#{comment}"
    order.save null, options

  canMakeTransaction: (transaction, contract) ->
    return { success: false, reason: 'Contract not found.' } unless contract

    switch transaction
      # check that user has enough account balance
      when 'buy'
        amount = contract.get transactionMap[transaction]
        if amount > @get('balance')
          return {
            success: false
            reason: "You don't have enough cåin to purchase #{contract.id}"
          }
        else
          return {
            success: true
          }
      # check that user holds this contract
      when 'sell'
        if @holdsPosition contract
          return {
            success: true
          }
        else
          return {
            success: false
            reason: "You don't hold any contracts for this future."
          }
