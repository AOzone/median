Q = require 'q'
_ = require 'underscore'
Backbone = require "backbone"
sd = require("sharify").data
Accounts = require '../../collections/accounts.coffee'

@forecasters = (req, res, next) ->
  accounts = new Accounts []
  accounts.url = "#{sd.KERNAL_API_URL}/leaderboard/forecaster"

  accounts.fetch
    success: ->
      res.render 'forecasters',
        accounts: accounts
    error: (err, response) ->
      next err

@influencers = (req, res, next) ->
  accounts = new Accounts []
  accounts.url = "#{sd.KERNAL_API_URL}/leaderboard/influencer"

  accounts.fetch
    success: ->
      res.render 'influencers',
        accounts: accounts
    error: (err, response) ->
      next err

@activists = (req, res, next) ->
  accounts = new Accounts []
  accounts.url = "#{sd.KERNAL_API_URL}/leaderboard/activist"

  accounts.fetch
    success: ->
      res.render 'activists',
        accounts: accounts
    error: (err, response) ->
      next err
