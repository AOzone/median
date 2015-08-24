Q = require 'q'
_ = require 'underscore'
Backbone = require "backbone"
sd = require("sharify").data

@login = (req, res, next) ->
  res.render 'login'

@sendToken = (req, res, next) ->
  res.render 'login'