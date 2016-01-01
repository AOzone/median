Backbone = require 'backbone'
{ KERNAL_API_URL } = require '../config.coffee'
transactionMap = require '../maps/transactions.coffee'
{ authTokenPair } = require '../lib/util/token.coffee'
numeral = require 'numeral'
_ = require 'underscore'

User = require '../db/models/user'
request = require 'request'

module.exports = class Account extends Backbone.Model

  url: -> "#{KERNAL_API_URL}/accounts/#{@idOr_id()}"

  idOr_id: ->
    @id or @get('_id')

  orNull: ->
    if sd.CURRENT_USER then new @(sd.CURRENT_USER) else null

  formatBalance: ->
    "#{numeral(@get('balance')).format('0,0')}Å"

  formatCurrency: (attr) ->
    "#{numeral(@get(attr)).format('0,0')}Å"

  totalPortfolioValue: ->
    total = _.reduce @get('open_positions'), (memo, position) ->
      memo + position.current_value
    , 0

    "#{numeral(total).format('0,0')}Å"

  totalGain: ->
    total = _.reduce @get('open_positions'), (memo, position) ->
      memo + position.gain_loss
    , 0

    "#{numeral(total).format('0,0')}Å"

  holdsPosition: (contract) ->
    _.any @get('open_positions'), (position) ->
      position.contract is contract.get('contract')

  # check if Account is able to make the purchase
  canMakePurchase: ({ good_id, price }, callback) ->
    # if Account has enough in it to make the purchase
    # if User doesn't already own the property

    username = @id or @get('_id')

    if @get('balance') >= price # check if user has enough balance
      User.findOne { 'username' :  username }, (err, user) ->
        if err
          console.log "Cannot find user in the User database: " + err
          callback(false, "Cannot find user in the User database: " + err)
        else # check if already purchased
          if user.goods
            already_purchased = _.find user.goods, (item) ->
              item.id == good_id

            console.log "already_purchased: " + already_purchased

            if already_purchased
              console.log "-------cannot make purchase: User already purchased this good"
              callback(false, "You already purchased this good")
            else
              console.log "-------can make purchase"
              callback(true, null)
          else
            console.log "-------can make purchase"
            callback(true, null)
    else
      console.log "Not enough funds"
      callback(false, "You do not have enough cåin to make this purchase")


  # make a transfer from this account to another account through the kernel
  makeKernelTransfer: ({ to_account, amount, comment }, callback) ->
    { authId, authToken } = authTokenPair()
    params = "?auth_id=#{authId}&auth_token=#{authToken}"

    # todo: replace this with tokenizer that sanitizes for URL transfer
    comment = "comment=testing"

    url = "#{@url()}/transfer/#{to_account}/#{amount}/#{params}" # &#{comment}

    console.log "-------sending PUT to: " + url

    # execute the transfer via the kernel using a PUT request
    request.put url, (error, response, body) ->
      if error or response.statusCode != 200
        console.log "response.statusCode: " + response.statusCode
        console.log "Error completing purchase transfer with kernel: " + error
        callback(false, "Error completing transaction with kernel: " + error )
      else
        console.log "***Successfully completed purchase transfer with kernel"
        callback(true, null)


  # update the User db with the new balance and account information
  updateAccountWithPurchase: ({ good_type, good_id, price }, callback) ->
    username = @id or @get('_id')

    # add the new good to the mongo User's params
    User.update { "username": username }, { $push: goods: { "type": good_type, "id": good_id , "price": price } }, { upsert: true }, (err) ->
      if err
        console.log "Error updating User in mongo db: " + err
        callback(false, "Error updating User in mongo db: " + err )
      else
        console.log '****Successfully added purchase to User in mongo db'
        callback(true)


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
