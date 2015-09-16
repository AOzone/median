crypto = require 'crypto'
sha224 = require('js-sha256').sha224
{ KERNAL_SECRET } = require '../../config.coffee'

module.exports =
  authId: ->
    crypto.randomBytes(Math.ceil(5))
      .toString('hex')
      .slice(0, 10)

  authTokenPair: ->
    authToken = sha224(KERNAL_SECRET + (authId = module.exports.authId())).toString('hex')
    { authToken: authToken, authId: authId }