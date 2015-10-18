mediator = require '../../../lib/mediator.coffee'
Contract = require '../../../models/contract.coffee'
Blocks = require '../../../collections/blocks.coffee'
transactionMap = require '../../../maps/transactions.coffee'
contractMap = require '../../../maps/contracts.coffee'

module.exports =
  initCallSign: ->
    return unless sd.CURRENT_USER

    $('body').on 'click', '.js-make-transaction:not(.disabled)', (e) ->
      $target = $(e.currentTarget)

      {
        contract_title,
        contract_id,
        contract_bid,
        contract_ask,
        transaction,
        item_id,
        item_title
      } = $target.data()

      contract = new Contract
        contract: contract_id
        title: contract_title
        bid: contract_bid
        ask: contract_ask

      if item_id && item_title
        mediator.trigger 'confirm:trade',
          model: contract
          title: item_title
          block_id: item_id
          transaction:transaction
          map: transactionMap
      else
        news = new Blocks [], id: contractMap[contract_id]['channel_id']

        mediator.trigger 'choose:news',
          model: contract
          blocks: news
          transaction: transaction
          map: transactionMap

    $('.call-sign').tooltipster
      content: 'Loading...'
      contentAsHTML: true
      interactive: true
      autoClose: true
      positionTracker: true
      speed: 0
      updateAnimation: false
      offsetY: 10
      theme: 'tooltipster-azone'
      functionBefore: ($origin, continueTooltip) ->
        continueTooltip()
        $.ajax
          type: 'GET'
          url: "#{sd.APP_URL}/investing/futures/#{$origin.data('contract_id')}/tooltip"
          data:
            item_id: $origin.data('item_id')
            item_title: $origin.data('item_title')
          success: (data) ->
            bgColor = $(data).css('backgroundColor')
            elem = $origin.tooltipster('elementTooltip')
            $(elem).css 'backgroundColor', bgColor
            $(elem).css('borderColor', '#fff') if $origin.data('show_border')
            $origin.tooltipster('content', data)
              .data('ajax', 'cached')
              .tooltipster('option', 'arrowColor', bgColor)
              .tooltipster('reposition')

