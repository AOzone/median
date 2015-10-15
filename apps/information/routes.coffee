@index = (req, res, next) ->
  res.render "about"

@page = (req, res, next) ->
  res.render req.params.page
