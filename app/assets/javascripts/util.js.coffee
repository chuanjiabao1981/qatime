(($)->
  // 阻止表单重复提交
  // 如果表单需要重复提交添加class="duplicate"
  $.fn.preventDup = ->
    $(this).submit ->
      return true if $(this).hasClass("duplicate")
      return false if $(this).hasClass("submiting")
      $(this).addClass("submiting")

  // 字符串替换
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

jQuery ->
  $("form").on "ajax:complete", ->
    $(this).removeClass("submiting")


