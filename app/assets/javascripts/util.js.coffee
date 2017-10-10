"use strict";

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
      return '' unless str
      str = str.replace(/</g, "&lt;")
      str = str.replace(/>/g, "&gt;")
    replaceChatMsg: (str) ->
      return '' unless str
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
      end_minutes = (minutes+duration_value) % 60
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


# 弹幕
window.Barrage = (id, options) ->
  id = "#" + id if 0 != id.indexOf("#")
  this.node = $(id)
  this.active = true
  # 显示消息
  this.show = (msg)->
    return false unless this.active
    # 视频宽度
    videoWidth = this.node.width()
    # 视频高度
    videoHeight = this.node.height()
    # 弹幕显示顶部位置
    # 视频区域上部1/3区域
    barrageTop = (videoHeight / 3 * Math.random()).toFixed(4)
    # 弹幕文字颜色
    barrageColor = 'rgb('+Math.floor(Math.random()*256)+','+Math.floor(Math.random()*256)+','+Math.floor(Math.random()*256)+')'
    # 创建弹幕节点
    barrageNode = $('<div class="barrage-node" style="position: absolute; color: ' + barrageColor + '; display: none;">' + msg + '</div>')
    barrageNode.css('font-size', "18px");
    $("#my-video").append(barrageNode)
    console.log(barrageNode);
    barrageNode.css("top", barrageTop)
    barrageWidth = barrageNode.width()
    totalWidth = barrageWidth + videoWidth
    barrageNode.css("left", videoWidth)
    # 设置弹幕动画
    barrageNode.show().css("top", barrageTop + "px").animate({
      left: "-=" + totalWidth,
    },
    5000,
    ->
      barrageNode.remove()
    )

  # 清楚屏幕
  this.clear = ->
    this.node.children(".barrage-node").remove();

  # 打开弹幕
  this.turnOn = ->
    this.active = true

  # 关闭弹幕
  this.turnOff = ->
    this.active = false
    this.clear()
  this
