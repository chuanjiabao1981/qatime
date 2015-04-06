# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

sumitVideo = (token,videoFile)->
  deferredVideoUpload = $.Deferred()
  videoForm = """
    <form id="videos_upload" action="/teaching_videos" enctype="multipart/form-data" method="post">
    </form>
  """
  videoFormData = new FormData
  videoFormData.append "teaching_video[token]", token
  videoFormData.append "teaching_video[name]" , videoFile
  $(videoForm).ajaxSubmit
    formData: videoFormData
    dataType: 'json'
    uploadProgress: (event, position, total, percentComplete)->
      percentVal = percentComplete + '%'
      deferredVideoUpload.notify percentVal
    error: (xhr, status, error) ->
      deferredVideoUpload.reject xhr.status
    success: (responseText, statusText, xhr, $form) ->
      deferredVideoUpload.resolve responseText.id

  deferredVideoUpload.promise()

((factory) ->

  ### global define ###

  if typeof define == 'function' and define.amd
    # AMD. Register as an anonymous module.
    define [ 'jquery' ], factory
  else
    # Browser globals: jQuery
    factory window.jQuery
  return
) ($) ->
  # template
  tmpl = $.summernote.renderer.getTemplate()
  # core functions: range, dom
  range = $.summernote.core.range
  dom = $.summernote.core.dom

  ###*
  # createVideoNode
  #
  # @member plugin.video
  # @private
  # @param {String} url
  # @return {Node}
  ###

  createVideoNode = (id) ->
    url = "//#{window.location.host}/teaching_videos/#{id}"
    v = $('<iframe>').attr('frameborder', 0).attr('src', url).attr('width', '640').attr('height', '360');
    v[0]

  ###*
  # @member plugin.video
  # @private
  # @param {jQuery} $editable
  # @return {String}
  ###

  getTextOnRange = ($editable) ->
    $editable.focus()
    rng = range.create()
    # if range on anchor, expand range with anchor
    if rng.isOnAnchor()
      anchor = dom.ancestor(rng.sc, dom.isAnchor)
      rng = range.createFromNode(anchor)
    rng.toString()

  ###*
  # toggle button status
  #
  # @member plugin.video
  # @private
  # @param {jQuery} $btn
  # @param {Boolean} isEnable
  ###

  toggleBtn = ($btn, isEnable) ->
    $btn.toggleClass 'disabled', !isEnable
    $btn.attr 'disabled', !isEnable
    return

  ###*
  # Show video dialog and set event handlers on dialog controls.
  #
  # @member plugin.video
  # @private
  # @param {jQuery} $dialog
  # @param {jQuery} $dialog
  # @param {Object} text
  # @return {Promise}
  ###

  showVideoDialog = ($editable, $dialog,text) ->
    $.Deferred((deferred) ->
      $videoDialog = $dialog.find('.note-video-dialog')
      $videoUrl     = $videoDialog.find('.note-video-url')
      $videoBtn     = $videoDialog.find('.note-video-btn')
      $progressBar  = $videoDialog.find('.progress-bar')
      $videoDialog.one('shown.bs.modal', ->
        $videoUrl.on('change', ->
          toggleBtn $videoBtn, true
          return
        )

        $videoBtn.click (event) ->
          event.preventDefault()
          sumitVideo($('div#qa_answer_params').data('token'),$videoUrl[0].files[0]).done((video_url)->
            deferred.resolve(video_url)
            $videoDialog.modal 'hide'
            return
          ).fail((status)->
            alert(status)
            deferred.reject()
            $videoDialog.modal 'hide'
            return
          ).progress((percent)->
            $progressBar.css({width: percent})
            $progressBar.text(percent)
            if percent == '100%'
              $progressBar.text("视频上传完毕，格式转换中请稍后。。。。")
          )
        return
      ).one('hidden.bs.modal', ->
        $progressBar.css({width: "0%"})
        $progressBar.text("0%")
        toggleBtn $videoBtn, false
        $videoUrl.val('')
        $videoUrl.off 'input'
        $videoBtn.off 'click'
        if deferred.state() == 'pending'
          deferred.reject()
        return
      ).modal 'show'
    )
  ###
  # @class plugin.video
  #
  # Video Plugin
  #
  # video plugin is to make embeded video tag.
  #
  ###

  $.summernote.addPlugin
    name: 'video'
    buttons: video: (lang) ->
      tmpl.iconButton 'fa fa-youtube-play',
        event: 'showVideoDialog'
        title: '教学视频'
        hide: true
    dialogs: video: (lang) ->
      body = '<div class="form-group row-fluid">' + '<label>' + '视频' + ' <small class="text-muted">' + '视频长度不要超过10分钟' + '</small></label>' +
      '<input class="note-video-url form-control span12" type="file" />' +
      '<div class="progress"><div class="progress-bar" role="progressbar"></div></div>' + '</div>'
      footer = '<button href="#" class="btn btn-primary note-video-btn disabled" disabled>' + '视频上传' + '</button>'
      tmpl.dialog 'note-video-dialog', '教学视频', body, footer
    events: showVideoDialog: (event, editor, layoutInfo) ->
      $dialog = layoutInfo.dialog()
      $editable = layoutInfo.editable()
      text = getTextOnRange($editable)
      # save current range
      editor.saveRange $editable
      showVideoDialog($editable, $dialog,text).then((url) ->
        # when ok button clicked
        # restore range
        editor.restoreRange $editable
        # build node
        $node = createVideoNode(url)
        if $node
          # insert video node
          editor.insertNode $editable, $node
        return
      ).fail ->
        # when cancel button clicked
        editor.restoreRange $editable
        return
      return
  return