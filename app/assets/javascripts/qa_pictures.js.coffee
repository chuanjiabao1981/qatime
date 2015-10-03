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


getToken = ->
  k = "undefine"
  for i in $("input[id$='_token']")
    if k == "undefine"
      k = i.value
    else if k != i.value
      alert(" token not same do something.......")

  return k


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
    $dialog.find('#qa-img-preview').attr('src','')
    $dialog.find('#qa-img-preview').removeAttr('width')
    $dialog.find('#qa-img-preview').removeAttr('height')

    $dialog.find('#qa-img-preview').removeClass('rotate0 rotate90 rotate180 rotate270')


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

  showImageDialog = ($editable, $dialog,text) ->
    $.Deferred((deferred) ->
      $qaImageDialog  = $dialog.find('.note-qa-image-dialog')
      $imageUrl       = $qaImageDialog.find('.note-qa-image-url')
      $imageBtn       = $qaImageDialog.find('.note-qa-image-btn')
      $progressBar    = $qaImageDialog.find('.progress-bar')
      $qaImageDialog.one('shown.bs.modal', ->

        $imageBtn.click (event) ->
          event.preventDefault()
          canvas    = document.getElementById('image-canvas');
          data      = canvas.toDataURL('image/jpeg')
          blob      = window.dataURLtoBlob && window.dataURLtoBlob(data);
          fileName  = $imageUrl[0].files[0].name

          token = getToken()
          if token == "undefine"
            alert("no token is given")
            return
          sumitPicture(token,blob,fileName).done((qa_image_url)->
            deferred.resolve(qa_image_url)

            $qaImageDialog.modal 'hide'
            return
          ).fail((status)->
            alert(status)
            deferred.reject()
            $qaImageDialog.modal 'hide'
            return
          ).progress((percent)->
            $progressBar.css({width: percent})
            $progressBar.text(percent)
            if percent == '100%'
              $progressBar.text("图片上传完毕,格式转换中，请稍后。。。。。")
          )
        return
      ).one('hidden.bs.modal', ->
        $progressBar.css({width: "0%"})
        $progressBar.text("0%")
        toggleBtn $imageBtn, false
        $imageUrl.val('')
        $imageUrl.off 'input'
        $imageBtn.off 'click'
        if deferred.state() == 'pending'
          deferred.reject()
        return
      ).modal 'show'
    )
  ###
  # @class plugin.qa_image
  #
  # Qa_Image Plugin
  #
  #
  ###

  $.summernote.addPlugin
    name: 'qa_image'
    buttons: qa_image: (lang) ->
      tmpl.iconButton 'fa fa fa-picture-o',
        event: 'showImageDialog'
        title: '上传图片'
        hide: true
    dialogs: qa_image: (lang) ->
      body =
        '<div class="form-group row-fluid">' + '<label>' + '图片' + '</small></label>' +
        '<input class="note-qa-image-url form-control span12" type="file" id="qa-img-file"/>' +
        '<label>图片预览<br/><strong style="color:red">' +
          '1. 同学你好，请拍摄照片时，镜头垂直对准页面,在光线好的情况下进行拍摄<br/>'+
          '2. 同学你好，如果图片是颠倒的话，请点击下边的"翻转"按钮进行调整。否则老师看起来很幸苦。谢谢亲:)' +
          '</strong></label>'+
        '<button id="qa-img-rotate">翻转</button>'+
        '<div style="width: 400px;height: 400px;border: 1px dotted gray">'+
        '<img id="qa-img-preview" src="" />'+
        '</div>'+
        '<canvas id="image-canvas"   style="display: none"></canvas>' +
        '<div class="progress"><div class="progress-bar" role="progressbar"></div></div>' + '</div>'
      footer = '<button href="#" class="btn btn-primary note-qa-image-btn disabled" disabled>' + '上传图片' + '</button>'
      tmpl.dialog 'note-qa-image-dialog', '上传图片', body, footer
    events: showImageDialog: (event, editor, layoutInfo) ->
      __qa_pictures_init()

      $dialog = layoutInfo.dialog()
      $editable = layoutInfo.editable()
      text = getTextOnRange($editable)
      clearAttribute($dialog)

      # save current range
      editor.saveRange $editable
      showImageDialog($editable, $dialog,text).then((url) ->
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
          'width': 400
          'height': 400
        #清除掉上一次遗留的css信息
        $('#qa-img-preview').removeClass('rotate0 rotate90 rotate180 rotate270')
        canvas = document.getElementById('image-canvas');
        canvas.width     = $('#qa-img-preview')[0].naturalWidth
        canvas.height    = $('#qa-img-preview')[0].naturalHeight

        ctx = canvas.getContext('2d')
        ctx.drawImage(image,0,0,canvas.width,canvas.height)
        $imageBtn       = $('.note-qa-image-btn')

        $imageBtn.toggleClass 'disabled', false
        $imageBtn.attr 'disabled', false

      return

    reader.readAsDataURL input.files[0]
  return
#$ ->
#
#  $("input#qa-img-file").change ->
#    readURL this
#  download = document.getElementById('canvas-download')
#  download.addEventListener 'click', (->
#    canvas = document.getElementById('image-canvas');
#    data = canvas.toDataURL()
#    download.href = data
#    return
#  ), false

__qa_pictures_init = ->
  $("input#qa-img-file").change ->
    readURL this
  image_rotate = $('button#qa-img-rotate')
  image        = $('img#qa-img-preview')
  angle        = 0
  # 绑定rotate事件
  image_rotate.click (event)  ->
    # 不让对话框响应这个事件
    event.preventDefault()

    # 只有有图片的时候才进行翻转
    if image[0].width == 0
      return

    # 如果没有class 则证明图片重新加载过，重设angle
    if not image.hasClass('rotate0') and  not image.hasClass('rotate90') and not image.hasClass('rotate180') and not image.hasClass('rotate270')
      angle = 0

    angle = (angle + 90 ) % 360
    #css 翻转
    image.attr("class","rotate"+angle);

    canvas               = document.getElementById('image-canvas')
    ctx                  = canvas.getContext('2d')
    # 清理
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    if (angle == 0 || angle == 180)

      ctx.canvas.width     = image[0].naturalWidth
      ctx.canvas.height    = image[0].naturalHeight
    else

      ctx.canvas.width     = image[0].naturalHeight
      ctx.canvas.height    = image[0].naturalWidth

    ctx.save()
    ctx.translate(canvas.width / 2, canvas.height / 2);
    ctx.rotate(angle * Math.PI/180)
    if (angle == 0 || angle == 180)
      ctx.drawImage(image[0],-canvas.width/2, -canvas.height/2,canvas.width,canvas.height)
    else
      ctx.drawImage(image[0],-canvas.height/2,-canvas.width/2,canvas.height,canvas.width)

    ctx.restore()
    return

