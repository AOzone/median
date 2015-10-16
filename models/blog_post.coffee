Backbone = require 'backbone'
moment = require 'moment'
authorDescriptions = require '../maps/author_descriptions'
{ WORDPRESS_API_URL, APP_URL } = require '../config'

module.exports = class BlogPost extends Backbone.Model
  url: (options) -> "#{WORDPRESS_API_URL}/posts/slug:#{@get('slug')}"

  getAuthorDescription: ->
    authorDescriptions[@get('author').login] || ''

  getFormattedDate: ->
    moment(@get('date')).format('d MMMM YYYY')
