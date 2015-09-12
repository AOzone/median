BaseArenaCollection = require './base_arena_collection.coffee'
sd = require("sharify").data
_ = require 'underscore'
Block = require '../models/block.coffee'

module.exports = class Blocks extends BaseArenaCollection

  url: -> "#{sd.ARENA_API_URL}/channels/#{@id}/contents"

  initialize: ( models, { @id } )->
    super

  parse: (data) ->
    data.contents