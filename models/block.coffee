Backbone = require 'backbone'
sd = require("sharify").data
_ = require 'underscore'

module.exports = class Block extends Backbone.Model

  url: -> "#{sd.ARENA_API_URL}/blocks/#{@id}"
