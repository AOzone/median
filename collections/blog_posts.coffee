Backbone = require 'backbone'
params = require 'query-params'
BlogPost = require '../models/blog_post'
{
  WORDPRESS_API_URL,
  WORDPRESS_API_TOKEN,
  APP_URL
} = require '../config'

POSTS_PER_PAGE = 20

module.exports = class BlogPosts extends Backbone.Collection
  model: BlogPost

  url: -> "#{WORDPRESS_API_URL}/posts?#{params.encode(@options)}"

  initialize: (models, options) ->
    @options = options
    super

  sync: (method, model, options) ->
    options?.headers ?= {}
    options.headers['Authorization'] = "Bearer: #{WORDPRESS_API_TOKEN}"
    super

  parse: (data) ->
    data.posts

  getNextPageUrl: ->
    @models.length < POSTS_PER_PAGE &&
      @getPageUrl(offset: @options.offset + POSTS_PER_PAGE)

  getPreviousPageUrl: ->
    @options.offset > 0 &&
      @getPageUrl(offset: @options.offset - POSTS_PER_PAGE)

  getPageUrl: (offset) ->
    "#{APP_URL}/blog?offset=#{offset}"
