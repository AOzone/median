_ = require 'underscore'
Headroom = require 'headroom.js'


module.exports = ->
  $navOverlay = $('.js-nav-overlay')
  $navOverlayOpen = $('.js-nav-overlay-open')
  $navOverlayClose = $('.js-nav-overlay-close')

  unless $('body').hasClass('is-light-nav') or $('body').hasClass('is-exhibition')
    myElement = document.querySelector("nav.nav")
    headroom  = new Headroom(myElement)
    headroom.init()

  $navOverlayOpen.click (e) ->
    e.preventDefault()
    $navOverlay.show()
    _.defer ->
      $navOverlay.attr 'data-state', 'active'

  $navOverlayClose.click (e) ->
    e.preventDefault()
    $navOverlay.attr 'data-state', 'inactive'
    _.delay ->
      $navOverlay.hide()
    , 500
