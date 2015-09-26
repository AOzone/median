BaseArenaCollection = require './base_arena_collection.coffee'
sd = require("sharify").data
_ = require 'underscore'
Block = require '../models/block.coffee'

module.exports = class Blocks extends BaseArenaCollection
  model: Block

  url: -> "#{sd.ARENA_API_URL}/channel/#{@id}/search"

  initialize: ( models, { @id } )->
    super

  parse: (data) ->
    data.blocks