(($)->
  $.fn.preventDup = ->
    $(this).submit ->
      return true if $(this).hasClass("duplicate")
      return false if $(this).hasClass("submiting")
      $(this).addClass("submiting");
)(jQuery)
