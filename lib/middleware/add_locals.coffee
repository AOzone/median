{ parse } = require 'url'

module.exports = (req, res, next) ->
  if req.user
    res.locals.user = req.user
    res.locals.sd?.CURRENT_USER = req.user.toJSON()

  res.locals.sd?.CURRENT_PATH = parse(req.url).pathname

  next()
