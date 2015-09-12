BaseArenaModel = require './base_arena_model.coffee'
sd = require("sharify").data
_ = require 'underscore'

module.exports = class Block extends BaseArenaModel

  url: -> "#{sd.ARENA_API_URL}/blocks/#{@id}"
