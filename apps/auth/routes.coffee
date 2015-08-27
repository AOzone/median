Q = require 'q'
_ = require 'underscore'
Backbone = require "backbone"
sd = require("sharify").data
passwordless = require 'passwordless'

@login = (req, res, next) ->
  res.render 'login'

@sendToken = passwordless.requestToken (user, delivery, callback) ->
    console.log 'user', user, delivery, callback
    callback null, user
  , (req, res) ->
    res.render 'login'
