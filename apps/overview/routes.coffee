contributors = require '../../maps/contributors.coffee'
markdown = require '../../components/util/markdown'

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

@contributors = (req, res, next) ->
  res.locals.sd.CONTRIBUTORS = contributors
  res.render 'contributors',
    contributors: contributors
    markdown: markdown
