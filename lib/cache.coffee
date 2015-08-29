_ = require 'underscore'
{ NODE_ENV, REDIS_URL, DEFAULT_CACHE_TIME } = require '../config'
redis = require 'redis'
@client = null

# Setup redis client
@setup = (callback) ->
  return callback() if NODE_ENV is "test" or not REDIS_URL
  red = require("url").parse(REDIS_URL)
  @client = redis.createClient(red.port, red.hostname)
  @client.on 'error', _.once (err) =>
    @client = null
    callback()
  @client.on 'ready', _.once callback
  @client.auth(red.auth.split(":")[1]) if @client and red.auth

# Convenience for setting a value in the cache with an expiry.
#
# @param {String} key
# @param {String} val
# @param {Number} expiresIn Defaults to 30 mins
@set = (key, val, expiresIn = 1800) =>
  return unless @client?
  @client.set key, val
  @client.expire key, expiresIn

# Safe alias of get
#
# @param {String} key
# @param {Function} callback
@get = (key, callback) =>
  return callback() unless @client?
  @client.get key, callback

# Safe alias of del
#
# @param {String} key
# @param {Function} callback
@del = (key, callback) =>
  return callback() unless @client?
  @client.del key, callback

# Iterates through a hash and calls JSON.stringify on each value. This is useful
# when storing a big hash of models/collections to be deserialized later (e.g. on the fair page).
#
# @param {String} key Redis key
# @param {Object} hash

@setHash = (key, hash) =>
  return unless @client?
  serialized = {}
  serialized[k] = JSON.stringify(v) for k, v of hash
  @client.set key, JSON.stringify hash
  @client.expire key, DEFAULT_CACHE_TIME

# Retrieves a serialized hash from `setHash` and deserializes it into models and
# collections. Pass in a hash of key: Model/Colllection class pairs to indicate what each
# key gets deserialized into.
#
# e.g.
#
# cache.getHash 'fair:' + id, {
#   fair: require('../../models/fair')
#   artworks: require('../../collections/artworks')
# }, ->
#
# @param {String} key Redis key to GET
# @param {Object} hash key: Model/Collection pairs
# @param {Function} callack Calls back with (err, deserializedHash)

@getHash = (key, hash, callback) =>
  return callback() unless @client?
  @client.get key, (err, json) ->
    return callback(err) if err
    if json
      data = JSON.parse json
      deserialized = {}
      for key, json of data
        klass = hash[key]
        deserialized[key] = if klass? then new klass(json) else json
      callback null, deserialized
    else
      callback()

@flushall = (callback) =>
  return callback() unless @client?
  @client.flushall callback