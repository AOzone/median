_ = require 'underscore'
{ initTableView } = require '../../contract_table/index.coffee'
{ initConfirmTrade } = require '../../confirm_trade/client/index.coffee'
{ initChooseNews } = require '../../choose_news/client/index.coffee'
{ getColor, lightOrDark } = require '../../color/index.coffee'
initNav = require '../../nav/client/index.coffee'

require 'jquery.transition'

module.exports.initLayout = ->
  initTableView()
  initConfirmTrade()
  initChooseNews()
  initNav()

  $('.js-gain-color').each (index) ->
    gain = $(this).data 'gain'
    color = getColor parseFloat gain
    $(this).css color: "##{color}"

  $('.js-gain-bg-color').each (index) ->
    gain = $(this).data 'gain'
    color = getColor parseFloat gain
    $(this).css backgroundColor: "##{color}"
