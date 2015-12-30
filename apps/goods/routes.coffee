contributors = require '../../maps/contributors.coffee'
markdown = require '../../components/util/markdown'
goods = require '../../maps/goods.coffee'
_ = require 'underscore'
numeral = require 'numeral'
Q = require 'bluebird-q'
sd = require("sharify").data
Account = require '../../models/account.coffee'

# renders /goods template with list of goods from map
@goods = (req, res, next) ->
  id = req.params.id or req.user?.id
  account = new Account id: id

  Q.all [
    account.fetch()
  ]
  .then ->
    res.locals.sd.GOODS = goods
    res.locals.sd.ACCOUNT = account.toJSON()

    res.render 'goods',
      goods: goods
      markdown: markdown
      account: account
      numeral: numeral
  .catch next
  .done()

# renders specific good based on markdown in map
@good = (req, res, next) ->
  console.log "@good render"
  id = req.params.id or req.user?.id
  account = new Account id: id

  good_id = req.params.property_id
  good_type = req.params.good_type

  go = _.find goods, (g) ->
    if g.id == good_id
      return g

  good = go[0]

  Q.all [
    account.fetch()
  ]
  .then ->
    res.render 'good',
      good: good
      good_type: good_type
      markdown: markdown
      account: account
  .catch next
  .done()

# executes purchase of good and redirects to that good's page
@makePurchase = (req, res, next) ->
  return next() unless req.user

  good_type = req.body.good_type
  good_id = req.body.good_id
  price = req.body.price
  comment = req.body.comment

  Q.all [
    # make the transfer with the kernel
    req.user.makePurchaseTransfer { good_type: good_type, good_id: good_id, price: price, comment: comment }
  ]
  .then -> # returns a {success, reason} object
    # refresh user balance
    req.logIn req.user, (err) ->
      # todo: catch error
      # send user to the good page
      res.redirect '/goods/' + good_type + '/' + good_id

  .catch (err) ->
    console.log "There was an error with Q promises in @makePurchase"
    console.dir err
    next
  .done()
