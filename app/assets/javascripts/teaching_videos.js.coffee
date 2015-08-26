# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#sumitVideo = (token,videoFile)->
#  deferredVideoUpload = $.Deferred()
#  videoForm = """
#    <form id="videos_upload" action="/teaching_videos" enctype="multipart/form-data" method="post">
#    </form>
#  """
#  videoFormData = new FormData
#  videoFormData.append "teaching_video[token]", token
#  videoFormData.append "teaching_video[name]" , videoFile
#  $(videoForm).ajaxSubmit
#    formData: videoFormData
#    dataType: 'json'
#    uploadProgress: (event, position, total, percentComplete)->
#      percentVal = percentComplete + '%'
#      deferredVideoUpload.notify percentVal
#    error: (xhr, status, error) ->
#      deferredVideoUpload.reject xhr.status
#    success: (responseText, statusText, xhr, $form) ->
#      deferredVideoUpload.resolve responseText.id
#
#  deferredVideoUpload.promise()

sumitPicture = (token,pictureFile,pictureFileName)->
  deferredPictureUpload = $.Deferred()
  pictureForm = """
    <form id="pictures_upload" action="/pictures" enctype="multipart/form-data" method="post">
    </form>
  """
  picutreFormData = new FormData
  picutreFormData.append "picture[token]", token
  picutreFormData.append "picture[name]" , pictureFile,pictureFileName
  $(pictureForm).ajaxSubmit
    formData: picutreFormData
    dataType: 'json'
    uploadProgress: (event, position, total, percentComplete)->
      percentVal = percentComplete + '%'
      deferredPictureUpload.notify percentVal
    error: (xhr, status, error) ->
      deferredPictureUpload.reject xhr.status
    success: (responseText, statusText, xhr, $form) ->
      deferredPictureUpload.resolve responseText.name.url


  deferredPictureUpload.promise()


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

  clearAttribute = ($dialog) ->
    console.log($dialog.find('#qa-img-preview'))


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
          canvas    = document.getElementById('image-canvas-r');
          console.log(canvas)
          data      = canvas.toDataURL('image/jpeg')
          blob      = window.dataURLtoBlob && window.dataURLtoBlob(data);
          fileName  = $videoUrl[0].files[0].name
          sumitPicture($('div#qa_answer_params').data('token'),blob,fileName).done((video_url)->
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
              $progressBar.text("图片上传完毕,格式转换中。。。。。")
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
      body =
      '<div class="form-group row-fluid">' + '<label>' + '视频' + ' <small class="text-muted">' + '视频长度不要超过10分钟' + '</small></label>' +
      '<input class="note-video-url form-control span12" type="file" id="qa-img-file"/>' +
      '<img id="qa-img-preview" src=""/>'+
      '<canvas id="image-canvas"   style="display: none"></canvas>' +
      '<a href="#" id="canvas-download">Download as image</a>'+
      '<a id="qa-img-rotate">翻转</a>'+
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

        #insert image
        editor.insertImage($editable, url)
        clearAttribute($dialog)
        return
      ).fail ->
        # when cancel button clicked
        editor.restoreRange $editable
        return
      return
  return
readURL = (input) ->
  if input.files and input.files[0]
    reader = new FileReader

    reader.onload = (e) ->
      image = new Image();
      image.src = e.target.result
      image.onload = ->


        $('#qa-img-preview').attr
          'src': e.target.result
          'width': 500
          'height': 500
        canvas = document.getElementById('image-canvas');
        canvas.width     = $('#qa-img-preview')[0].naturalWidth
        canvas.height    = $('#qa-img-preview')[0].naturalHeight

        ctx = canvas.getContext('2d')
        ctx.drawImage(image,0,0,canvas.width,canvas.height)

      return

    reader.readAsDataURL input.files[0]
  return
$ ->
  $("input#qa-img-file").change ->
    readURL this
  download = document.getElementById('canvas-download')
  download.addEventListener 'click', (->
    canvas = document.getElementById('image-canvas');
#    ctx = canvas.getContext('2d');
    data = canvas.toDataURL()
    download.href = data
    return
  ), false

$ ->
  image_rotate = $('a#qa-img-rotate')
  image        = $('img#qa-img-preview')
  angle        = 0
  image_rotate.click  ->

    angle = (angle + 90 ) % 360
    image.attr("class","rotate"+angle);

#    ctx.clearRect(0, 0, canvas.width, canvas.height);
    console.log($('canvas#image-canvas'))
    $('canvas#image-canvas').remove()

#    canvas               = document.getElementById('image-canvas')

    canvas               = document.createElement('canvas');
    canvas.setAttribute('id','image-canvas-r')
    document.body.appendChild(canvas)

    console.log($('canvas#image-canvas-r'))
    console.log(document.getElementById('image-canvas-r'))
    ctx                  = canvas.getContext('2d')

    ctx.canvas.width     = image[0].naturalWidth
    ctx.canvas.height    = image[0].naturalHeight
    if (angle == 0 || angle == 180)

      ctx.canvas.width     = image[0].naturalWidth
      ctx.canvas.height    = image[0].naturalHeight
    else

      ctx.canvas.width     = image[0].naturalHeight
      ctx.canvas.height    = image[0].naturalWidth

    console.log(canvas.width,canvas.height)
    ctx.save()
    ctx.translate(canvas.width / 2, canvas.height / 2);
    ctx.rotate(angle * Math.PI/180)
    ctx.drawImage(image[0],-canvas.width/2, -canvas.height/2,canvas.width,canvas.height);
    ctx.restore()
    return

