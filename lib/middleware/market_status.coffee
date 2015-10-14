Backbone = require 'backbone'
{ KERNAL_API_URL } = require '../../config.coffee'

module.exports = (req, res, next) ->
  status = new Backbone.Model
  status.url = "#{KERNAL_API_URL}/status"

  status.fetch
    complete: ->
      res.locals.status = status
      res.locals.sd?.MARKET_STATUS = status
      next()
