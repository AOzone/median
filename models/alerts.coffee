Backbone = require 'backbone'
sd = require("sharify").data
_ = require 'underscore'

module.exports = class Alerts extends Backbone.Model
  url: -> "#{sd.KERNAL_API_URL}/accounts/#{@user_id}/notifications"

  initialize: ({ @user_id }) ->
    # just destructured assigning

  parse: (data) ->
    data[0]

  allBlockIds: ->
    notifications = _.map @get('notifications'), (notification) ->
      _.map notification.all_rewards, (reward) -> reward.block_id
    _.uniq _.flatten notifications

