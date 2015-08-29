module.exports =
  authenticate: (req, res, next) ->
    if req.isAuthenticated()
      return next()
    res.redirect '/'