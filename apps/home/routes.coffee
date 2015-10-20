Q = require 'bluebird-q'
_ = require 'underscore'
sd = require("sharify").data
News = require '../../collections/news.coffee'
Contracts = require '../../collections/contracts.coffee'
contributors = require '../../maps/contributors.coffee'

@index = (req, res, next) ->
  blocks = new News []
  contracts = new Contracts []

  Q.all [
    blocks.fetch data: per: 10
    contracts.fetch()
  ]
  .then ->
    res.locals.sd.BLOCKS = blocks
    res.locals.sd.CONTRACTS = contracts

    contributors = _.last (_.shuffle contributors), 25

    res.render 'index',
      news: blocks
      contracts: contracts
      contributors: contributors
  .catch next
  .done()
