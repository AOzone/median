passwordless = require 'passwordless'
MongoStore = require 'passwordless-mongostore'
mongoURI = 'mongodb://localhost/passwordless-simple-mail'

passwordless.init new MongoStore(mongoURI)

passwordless.addDelivery (tokenToSend, uidToSend, recipient, callback) ->
  # Send out a token

app.use passwordless.sessionSupport()
app.use passwordless.acceptToken()