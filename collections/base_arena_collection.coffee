Backbone = require 'backbone'
{ ARENA_API_TOKEN } = require '../config.coffee'

module.exports = class BaseArenaCollection extends Backbone.Collection

  sync: (method, model, options)->
    options?.headers ?= {}
    options?.headers['X-AUTH-TOKEN'] = "#{ARENA_API_TOKEN}"
    super