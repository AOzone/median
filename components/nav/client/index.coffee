_ = require 'underscore'

module.exports = ->
  $navOverlay = $('.js-nav-overlay')
  $navOverlayOpen = $('.js-nav-overlay-open')
  $navOverlayClose = $('.js-nav-overlay-close')

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
