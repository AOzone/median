Backbone = require 'backbone'
sd = require("sharify").data
_ = require 'underscore'
Point = require '../models/point.coffee'

module.exports = class Chart extends Backbone.Collection
  model: Point

  url: -> "#{sd.KERNAL_API_URL}/charts/#{@id}/#{@type}"

  initialize: (models, { @id, @type }) ->
    # no op
