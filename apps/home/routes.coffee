Q = require 'bluebird-q'
_ = require 'underscore'
sd = require("sharify").data
Blocks = require '../../collections/blocks.coffee'
Contracts = require '../../collections/contracts.coffee'
Indices = require '../../collections/indices.coffee'
contributors = require '../../maps/contributors.coffee'
tech = require '../../maps/tech.coffee'

@index = (req, res, next) ->
  blocks = new Blocks [], id: 'the-hottest-tips'
  contracts = new Contracts []
  indices = new Indices []

  Q.all [
    blocks.fetch
      data: per: 10
      cache: true
    contracts.fetch()
    indices.fetch()
  ]
  .then ->
    res.locals.sd.BLOCKS = blocks
    res.locals.sd.CONTRACTS = contracts

    contributors = _.last (_.shuffle contributors), 25

    res.render 'index',
      news: blocks
      contracts: contracts
      tech: _.shuffle tech
      contributors: contributors
      statement: indices.statement()
  .catch next
  .done()
