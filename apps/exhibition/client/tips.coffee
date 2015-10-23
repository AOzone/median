module.exports.initTips = ->
  WH = $(window).height();
  SH = $('body')[0].scrollHeight;
  # $('html, body').stop().animate({scrollTop: SH - WH}, 20000, 'swing')
