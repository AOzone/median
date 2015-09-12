Backbone = require 'backbone'
{ ARENA_API_TOKEN } = require '../config.coffee'
_ = require 'underscore'

module.exports = class BaseArenaModel extends Backbone.Model

  sync: (method, model, options)->
    options?.headers['X-AUTH-TOKEN'] = "#{ARENA_API_TOKEN}"
    super


