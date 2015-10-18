sd = require("sharify").data
{ ARENA_API_TOKEN } = require '../../../config.coffee'
Backbone = require 'backbone'
modalize = require '../../modalize/index.coffee'
mediator = require '../../../lib/mediator.coffee'
Blocks = require '../../../collections/blocks.coffee'
transactionMap = require '../../../maps/transactions.coffee'

template = -> require('../templates/index.jade') arguments...
blocksTemplate = -> require('../../news_grid/templates/index.jade') arguments...

module.exports.ChooseNewsView = class ChooseNewsView extends Backbone.View
  className: 'v-outer'

  events:
    'click .news____grid-item' : 'selectOrCreateNews'
    'keyup #choose-news-search-input' : 'onKeyUp'

  initialize: ({ @model, @blocks, @transaction }) ->
    @blocks.fetch success: @render
    @collection = new Blocks [], id: null
    @collection.url = "#{sd.ARENA_API_URL}/user/azone-futures-market/search"

  onKeyUp: (e)->
    e.preventDefault()
    e.stopPropagation()

    switch e.keyCode
      when 13
        console.log('enter')
      when 40
        console.log('down')
      when 38
        console.log('up')
      else
        @search(e)

  getQuery: ->
    query = @$input.val()?.trim()
    if query.length
      return query
    else
      false

  isURL: ->
    string = @$input.val()
    urlregex = /^((ht{1}tp(s)?:\/\/)[-a-zA-Z0-9@:,!$%_\+.~#?&\(\)\/\/=]+)$/
    urlregex.test(string)

  search: (e) ->
    e.preventDefault()

    return @reset() unless query = @getQuery()
    return if (query.length < 2) or (query is @lastQuery)

    @$el.addClass('is-loading')

    @lastQuery = query

    @searchRequest.abort() if @searchRequest
    @searchRequest = @collection.fetch
      data:
        q: query
        per: 20
        auth_token: ARENA_API_TOKEN
      success: => @searchLoaded()

  searchLoaded: ->
    @$el.removeClass('is-loading')
    @$el.addClass('is-active')
    @$el.addClass('has-results')

    @$results.html blocksTemplate
      news: @collection
      isURL: @isURL()
      query: @getQuery()

  selectOrCreateNews: (e) ->
    @$(e.currentTarget).addClass 'is-disabled'

    if $(e.currentTarget).data('query')
      @createNews e
    else
      @selectNews e

  createNews: (e) ->
    $.ajax
      url: "#{sd.APP_URL}/investing/futures/#{@model.get('contract')}/add_news"
      type: "POST"
      data:
        url: @getQuery()
      success: (response) =>
        mediator.trigger 'confirm:trade',
          model: @model
          title: response.title
          block_id: response.block_id
          transaction: @transaction
          map: transactionMap
          is_new: true

        @trigger 'close'

  selectNews: (e) ->
    mediator.trigger 'confirm:trade',
      model: @model
      title: $(e.currentTarget).data('title')
      block_id: $(e.currentTarget).data('id')
      transaction: @transaction
      map: transactionMap

    @trigger 'close'

  render: =>
    @$el.html template
      news: @blocks
      contract: @model
      transaction: @transaction

    @postRender()

    return this

  postRender: ->
    @$input = @$('#choose-news-search-input')
    @$results = @$('.choose-news-grid')

module.exports.initChooseNews = ->
  mediator.on 'choose:news', (options) ->
    view = new ChooseNewsView options
    modal = modalize view
    modal.open()
