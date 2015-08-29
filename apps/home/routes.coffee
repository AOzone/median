Q = require 'q'
_ = require 'underscore'
Backbone = require "backbone"
sd = require("sharify").data

@index = (req, res, next) ->
  res.render 'index', message: req.flash('message')