(($)->
  # 阻止表单重复提交
  # 如果表单需要重复提交添加class="duplicate"
  $.fn.preventDup = ->
    $(this).submit ->
      return true if $(this).hasClass("duplicate")
      return false if $(this).hasClass("submiting")
      $(this).addClass("submiting")

  # 字符串替换
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

  # 广告轮播
  $.fn.rotate = (options) ->
    console.log $(this).children().size() 
    return if $(this).children().size() <= 1
    console.log('xxxxxxxxxxx')
)(jQuery)

jQuery ->
  $("form").on "ajax:complete", ->
    $(this).removeClass("submiting")

  $(".immediately").change ->
    $(this).parents("form").submit()

