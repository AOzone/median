@about = (req, res, next) ->
  res.render 'about'

@contact = (req, res, next) ->
  res.render 'contact'

@credits = (req, res, next) ->
  res.render 'credits'

@glossary = (req, res, next) ->
  res.render 'glossary'

@terms = (req, res, next) ->
  res.render 'terms'
