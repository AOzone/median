# jquery libs
require '../../../node_modules/waypoints/lib/jquery.waypoints.js'
require '../../../node_modules/waypoints/lib/shortcuts/sticky.js'
require '../../../lib/vendor/jquery.tooltipster.js'
require 'jquery.transition'

_ = require 'underscore'
{ initTableView } = require '../../contract_table/index.coffee'
{ initConfirmTrade } = require '../../confirm_trade/client/index.coffee'
{ initChooseNews } = require '../../choose_news/client/index.coffee'
{ initCallSign } = require '../../callsign/client/index.coffee'
{ getColor, lightOrDark } = require '../../color/index.coffee'
initNav = require '../../nav/client/index.coffee'

module.exports.initLayout = ->
  initTableView()
  initConfirmTrade()
  initChooseNews()
  initNav()
  initCallSign()

  $('.js-gain-color').each (index) ->
    gain = $(this).data 'gain'
    color = getColor parseFloat gain
    $(this).css color: "##{color}"

  $('.js-gain-bg-color').each (index) ->
    gain = $(this).data 'gain'
    color = getColor parseFloat gain
    $(this).css backgroundColor: "##{color}"

  $('.js-svg-fill-color').each (index) ->
    gain = $(this).data 'contract_gain'
    color = getColor parseFloat gain
    $(this).find('svg path').css fill: "##{color}"
