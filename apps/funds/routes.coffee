Q = require 'bluebird-q'
_ = require 'underscore'
Backbone = require "backbone"
sd = require("sharify").data
Account = require '../../models/account.coffee'
Positions = require '../../collections/positions.coffee'
Fund = require '../../models/fund.coffee'
Contracts = require '../../collections/contracts.coffee'

funds = require '../../maps/funds.coffee'
contributors = require '../../maps/contributors.coffee'
markdown = require '../../components/util/markdown'

@show = (req, res, next) ->
  fund = new Fund _.findWhere funds, { callsign: req.params.id }
  account = new Account id: fund.get('account_id')
  contributor = _.findWhere contributors, { name: fund.get('contributor_name') }
  contracts = new Contracts []

  return next() unless fund and fund.get('account_id') and contributor

  Q.all [
    account.fetch cache: true
    contracts.fetch cache: true
  ]
  .then ->
    positions = new Positions account.get('open_positions')
    positions.each (position) ->
      contract = contracts.findWhere({contract: position.get('contract')})
      position.set(contract.attributes) if contract

    res.locals.sd.POSITIONS = positions.toJSON()
    res.locals.sd.ACCOUNT = account.toJSON()

    res.render 'fund',
      fund: fund
      account: account
      positions: positions
      md: markdown
      contributor: contributor

  .catch next
  .done()
