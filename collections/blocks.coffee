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
    blocks = _.flatten _.values _.pick(data, ['contents', 'followers', 'users', 'channels', 'following', 'blocks', 'results'])
    _.filter blocks, (block) ->
      block.source and block.title

