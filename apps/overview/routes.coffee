@index = (req, res, next) ->
  page = res.locals.sd.TAB = "about"
  res.render page

@page = (req, res, next) ->
  page = res.locals.sd.TAB = req.params.page
  res.render page
