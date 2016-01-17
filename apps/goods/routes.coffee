contributors = require '../../maps/contributors.coffee'
markdown = require '../../components/util/markdown'
goods = require '../../maps/goods.coffee'
_ = require 'underscore'
numeral = require 'numeral'
Q = require 'bluebird-q'
sd = require("sharify").data
Account = require '../../models/account.coffee'
{ CENTRAL_BANK_ACCOUNT } = require '../../config.coffee'

testFunc = (foo) ->
  return foo + 'bar'

# renders /goods template with list of goods from map
@goods = (req, res, next) ->
  id = req.params.id or req.user?.id
  account = new Account id: id

  Q.all [
    account.fetch()
  ]
  .then ->
    res.locals.sd.GOODS = goods.goods
    res.locals.sd.ACCOUNT = account.toJSON()

    console.log "account:"
    console.dir account

    req.user.getPurchasedGoodsByID (purchased_goods, error) ->
      if error == null
        # prune out any goods already purchased by the user
        unpurchased_goods = []
        _.each goods.goods, (good) ->
          _.each purchased_goods, (pg) ->
            if good.id != pg
              unpurchased_goods.push(good)

        res.render 'goods',
          unpurchased_goods: unpurchased_goods
          markdown: markdown
          account: account
          numeral: numeral
      else
        req.flash 'error', error
        return res.redirect "/investing"

  .catch next
  .done()

# renders specific good based on markdown in map
@good = (req, res, next) ->
  console.log "@good render"
  id = req.params.id or req.user?.id
  account = new Account id: id

  good_id = req.params.good_id
  good_type = req.params.good_type

  go = _.find goods[good_type], (g) ->
    if g.id == good_id
      return g

  Q.all [
    account.fetch()
  ]
  .then ->
    res.render 'good',
      good: go
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

  # check if the user can make the purchase
  req.user.canMakePurchase { good_id: good_id, price: price },
    (success, err) ->
      unless success
        req.flash 'error', err
        return res.redirect "/goods"

      else
        # make the transfer with the kernel
        req.user.makeKernelTransfer { to_account: CENTRAL_BANK_ACCOUNT, amount: price, comment: comment },
          (success, msg) ->
            unless success
              req.flash 'error', msg
              return res.redirect "/goods"

            else
              # log the transfer in the User database
              req.user.updateAccountWithPurchase { good_type: good_type, good_id: good_id, price: price, transfer_id: msg },
                (success, error) ->
                  unless success
                    req.flash 'error', err
                    return res.redirect "/goods"

                  else
                    req.logIn req.user, (err) ->
                      # todo: catch error
                      # send user to the good page
                      res.redirect '/goods/' + good_type + '/' + good_id
