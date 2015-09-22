Q = require 'q'
_ = require 'underscore'
Backbone = require "backbone"
sd = require("sharify").data
Accounts = require '../../collections/accounts.coffee'

@index = (req, res, next) ->
  accounts = new Accounts []

  accounts.fetch
    success: ->
      res.render 'index',
        accounts: accounts