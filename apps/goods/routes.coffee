contributors = require '../../maps/contributors.coffee'
markdown = require '../../components/util/markdown'
goods = require '../../maps/goods.coffee'
_ = require 'underscore'

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
  .catch next
  .done()
