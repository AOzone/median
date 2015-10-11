Backbone = require 'backbone'
sd = require("sharify").data
{ ARENA_API_TOKEN } = require '../config.coffee'

module.exports = class BaseArenaCollection extends Backbone.Collection

  sync: (method, model, options)->
    options?.headers ?= {}
    token = ARENA_API_TOKEN or sd.ARENA_API_TOKEN
    console.log 'token', token
    options?.headers['X-AUTH-TOKEN'] = "#{token}"
    super