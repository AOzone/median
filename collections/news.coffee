params = require 'query-params'
Blocks = require './blocks.coffee'
sd = require("sharify").data
_ = require 'underscore'

module.exports = class News extends Blocks
  defaults:
    subject: 'blocks'
    page: 1
    per: 20

  url: -> "#{sd.ARENA_API_URL}/user/azone-futures-market/search?#{params.encode(@options)}"

  setOptions: ( options={} )->
    defaults = @defaults || {}
    current = @options || {}
    @options = _.extend {}, defaults, current, options

  initialize: ( models, options )->
    @setOptions options
