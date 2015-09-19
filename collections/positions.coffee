Backbone = require 'backbone'
sd = require("sharify").data
_ = require 'underscore'
Position = require '../models/position.coffee'

module.exports = class Positions extends Backbone.Collection

  model: Position