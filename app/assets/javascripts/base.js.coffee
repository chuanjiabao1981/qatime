$ ->
  $(document).on('click', '.weixinAudio', ->
    $(".weixinAudio .playing").weixinAudio().pause();
  )