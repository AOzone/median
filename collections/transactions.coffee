Backbone = require 'backbone'
sd = require("sharify").data
Transaction = require '../models/transaction.coffee'
_ = require 'underscore'

module.exports = class Transactions extends Backbone.Collection
  model: Transaction

  url: -> "#{sd.KERNAL_API_URL}/tips/#{@id}"

  initialize: (models, { @id }) ->
