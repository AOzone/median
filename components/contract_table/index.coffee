
module.exports.initTableView = ->
  $('body').on 'click', '.contract-list tbody tr', (e) ->
    $('.contract-list tbody tr.is-active').removeClass 'is-active'
    $(this).addClass 'is-active'