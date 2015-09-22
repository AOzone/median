Backbone = require 'backbone'
sd = require("sharify").data
Account = require '../models/account'
_ = require 'underscore'

module.exports = class Accounts extends Backbone.Collection
  model: Account

  url: -> "#{sd.KERNAL_API_URL}/accounts"
