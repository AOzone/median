Q = require 'q'
_ = require 'underscore'
Backbone = require "backbone"
sd = require("sharify").data
passwordless = require 'passwordless'

@login = (req, res, next) ->
  res.render 'login'

@sendToken = (req, res, next) ->
  console.log 'req.body.email', req.body.email
  passwordless.requestToken (user, delivery, callback) ->
    console.log 'user', user, delivery, callback
    callback null, req.body.email
  , (req, res) ->
    res.render 'login'
