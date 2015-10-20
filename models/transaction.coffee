Backbone = require 'backbone'
sd = require("sharify").data
moment = require 'moment'
_ = require 'underscore'

module.exports = class Transaction extends Backbone.Model

  getFormattedDate: ->
    moment(@get('date')).format('d MMMM YYYY')
