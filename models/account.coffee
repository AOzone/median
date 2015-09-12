Backbone = require 'backbone'
{ KERNAL_API_URL } = require '../config.coffee'
_ = require 'underscore'

module.exports = class Account extends Backbone.Model

  url: ->
    "#{KERNAL_API_URL}/accounts/#{@id}"

