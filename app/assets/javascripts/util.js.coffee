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
  $.fn.rotate = (options = {}) ->
    options['speed'] ||= 1000
    options['interval'] ||= 5000
    obj = $(this);
    count = obj.children().size()
    return if count <= 1
    step = parseFloat(obj.children(":first").css("width"))
    obj.append($(obj.children(":first").clone()))

    # 指示圆点
    dots = $("<ul class=\"banner-dot\"></ul>")
    dots.append("<li></li>") for i in [1..count]
    obj.after(dots)

    # 设置圆点选中
    obj.setDots = ->
      index = Math.abs(parseFloat(obj.css("left"))) / step
      obj.next(".banner-dot").children().removeClass("active").eq(index).addClass("active")
    
    # 开始轮播
    obj.start = ->
      obj.timer = setInterval ->
        obj.animate({
          left: "-=" + step
        },
        options['speed'],
        ->
          left = parseFloat(obj.css("left"))
          obj.css("left", 0) if left + count * step <= 0
          obj.setDots()
        )
      , options['interval']
    # 结束轮播
    obj.stop = ->
      clearInterval(obj.timer)
    obj.mouseover ->
      obj.stop()
    obj.mouseout ->
      obj.start()
    dots.mouseover ->
      obj.stop()
    dots.mouseout ->
      obj.start()
    # 点击圆点显示对应位置
    dots.click (event)->
      index = $(event.target).index()
      obj.css("left", -index * step)
      obj.next(".banner-dot").children().removeClass("active").eq(index).addClass("active")
    # 自动开始
    obj.setDots()
    obj.start()

  $.extend
    getLessonTime: (hour, minutes, duration) ->
      hour = parseInt(hour)
      minutes = parseInt(minutes)
      switch duration
        when 'minutes_30'
          duration_value = 30
        when 'minutes_45'
          duration_value = 45
        when 'hours_1'
          duration_value = 60
        when 'hours_half_90'
          duration_value = 90
        when 'hours_2'
          duration_value = 120
        when 'hours_half_150'
          duration_value = 150
        when 'hours_3'
          duration_value = 180
        when 'hours_half_210'
          duration_value = 210
        when 'hours_4'
          duration_value = 240
      end_hour = hour + parseInt((minutes+duration_value)/60)
      end_minutes = minutes+duration_value % 60
      if end_hour > 23
        end_hour = end_hour % 24
      if end_hour < 10
        end_hour = "0" + end_hour
      if end_minutes < 10
        end_minutes = "0" + end_minutes
      end_hour + ':' + end_minutes

)(jQuery)

jQuery ->
  $("form").on "ajax:complete", ->
    $(this).removeClass("submiting")

  $(".immediately").change ->
    $(this).parents("form").submit()

