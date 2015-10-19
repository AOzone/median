_ = require 'underscore'
Backbone = require 'backbone'
template = require './templates/index.coffee'

module.exports = class Modalize extends Backbone.View
  className: 'modalize'

  defaults: dimensions: width: '100%'

  events:
    'click .js-modalize-backdrop': 'maybeClose'
    'click .js-modalize-close': 'close'

  initialize: (options = {}) ->
    { @subView, @dimensions, @className } = _.defaults options, @defaults
    $(window).on 'keyup.modalize', @escape

    @subView.once 'close', @close, @

  state: (state, callback = $.noop) -> _.defer =>
    @$el
      .attr 'data-state', state
      .one $.support?.transition?.end, callback
      .emulateTransitionEnd 250

    $('body').attr 'data-state', "modal-#{state}"

  dialog: (state, callback = $.noop) ->
    duration = {
      slide: 500, fade: 250
    }[state.replace /-in|-out$/, '']

    @$dialog
      .attr 'data-state', state
      .one $.support.transition.end, callback
      .emulateTransitionEnd duration

  __render__: ->
    @$el.html template()
    @__rendered__ = true
    @state 'open'
    this

  render: ->
    unless @__rendered__
      @__render__()
      @trigger 'opening'
    @postRender()
    this

  __postRender__: ->
    (@$dialog = @$('.js-modalize-dialog')).css @dimensions
    (@$body = @$('.js-modalize-body')).html @subView.render().$el
    @__postRendered__ = true
    this

  postRender: ->
    unless @__postRendered__
      @__postRender__()
      @trigger 'opened'
    else
      @subView.render().$el
    this

  escape: (e) =>
    @close() if e.which is 27

  maybeClose: (e) ->
    @close() if $(e.target).hasClass('js-modalize-backdrop')

  close: (callback) ->
    $(window).off 'keyup.modalize'
    @trigger 'closing'
    @state 'close', =>
      @subView?.remove?()
      @remove()
      callback?()
      @trigger 'closed'
