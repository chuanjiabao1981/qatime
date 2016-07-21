(($)->
  $.fn.preventDup = ->
    $(this).submit ->
      return true if $(this).hasClass("duplicate")
      return false if $(this).hasClass("submiting")
      $(this).addClass("submiting")

  $.extend
    replaceBR: (str) ->
      str = str.replace(/\n/g, "<br />")
    replaceTag: (str) ->
      str = str.replace(/</g, "&lt;")
      str = str.replace(/>/g, "&gt;")
    replaceChatMsg: (str) ->
      str = $.replaceTag(str)
      str = $.replaceFaceEm(str)
      str = $.replaceBR(str)
)(jQuery)
