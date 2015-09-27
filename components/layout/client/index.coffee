{ initTableView } = require '../../contract_table/index.coffee'
{ getColor } = require '../../color/index.coffee'

module.exports.initLayout = ->
  initTableView()

  $('.js-gain-color').each (index) ->
    gain = $(this).data 'gain'
    color = getColor parseFloat gain
    $(this).css color: "##{color}"