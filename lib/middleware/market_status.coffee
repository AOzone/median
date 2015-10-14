Backbone = require 'backbone'
{ KERNAL_API_URL } = require '../../config.coffee'

module.exports = (req, res, next) ->
  return next() if req.path is '/sorry'
  status = new Backbone.Model
  status.url = "#{KERNAL_API_URL}/status"

  status.fetch
    success: ->
      res.locals.status = status
      res.locals.sd?.MARKET_STATUS = status
      next()
    error: ->
      return res.redirect '/sorry'
