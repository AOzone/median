Backbone = require 'backbone'
sd = require("sharify").data
_ = require 'underscore'
Block = require '../models/block.coffee'

module.exports = class Blocks extends Backbone.Collection
  model: Block
  url: -> "#{sd.ARENA_API_URL}/channels/#{@id}/contents"

  initialize: ( models, { @id } )->
    super

  parse: (data) ->
    data.contents