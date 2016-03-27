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
    dataType: 'script'
    format: 'js'
    uploadProgress: (event, position, total, percentComplete)->
      percentVal = percentComplete + '%'
      deferredPictureUpload.notify percentVal
    error: (xhr, status, error) ->
      deferredPictureUpload.reject xhr.status
    success: (responseText, statusText, xhr, $form) ->
#      deferredPictureUpload.resolve responseText.name.url
      deferredPictureUpload.resolve responseText
  deferredPictureUpload.promise()



updateQaPictureGallery =  ->
  $(".qa-picture-fancybox").fancybox({
    openEffect	: 'none',
    closeEffect	: 'none',
    nextClick   : true,
    maxWidth    : 1024,
    helpers	: {
      thumbs	: {
        width	  : 50,
        height	: 50
      },
      buttons	: {}
    }
  });

$(
  updateQaPictureGallery()
)

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
  $.extend(
    $.summernote.plugins,
    'qa_image': (context) ->
      ui = $.summernote.ui

      $editor = context.layoutInfo.editor;
      options = context.options;
      lang = options.langInfo;
      self = this
      context.memo 'button.qa_image', ->
        button = ui.button(
          contents: '<i class="fa fa fa-picture-o"/>'
          tooltop: '上传图片',
          click: =>
            self.show()
        )
        button.render()
      @events = {
        'summernote.init': (we, e) ->
          __qa_pictures_init()
      }

      @show = =>
        # $dialog = context.layoutInfo.dialog()
        # $editable = layoutInfo.editable()
        # text = getTextOnRange($editable)
        clearAttribute(@$dialog)

        # save current range
        context.invoke('editor.saveRange')

        self.showImageDialog().then((picture_json) ->
          # when ok button clicked
          # restore range
          context.invoke('editor.restoreRange');

          #insert image
          #editor.insertImage($editable, picture_json.name.url)
          #把图片通过fancybox展示
          #insertQaPicture picture_json
          updateQaPictureGallery()

          clearAttribute(self.$dialog)
          return
        ).fail ->
          # when cancel button clicked
          context.invoke('editor.restoreRange');
          return
        return

      @showImageDialog = ->
        $.Deferred (deferred) ->
          $qaImageDialog  = self.$dialog
          $imageUrl       = $qaImageDialog.find('.note-qa-image-url')
          $imageBtn       = $qaImageDialog.find('.note-qa-image-btn')
          $progressBar    = $qaImageDialog.find('.progress-bar')

          ui.onDialogShown self.$dialog, ->

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
              sumitPicture(token,blob,fileName).done((picture_json)->
                deferred.resolve(picture_json)

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

          ui.onDialogHidden(self.$dialog, ->
            $progressBar.css({width: "0%"})
            $progressBar.text("0%")
            toggleBtn $imageBtn, false
            $imageUrl.val('')
            $imageUrl.off 'input'
            $imageBtn.off 'click'
            if deferred.state() == 'pending'
              deferred.reject()
            return
          )
          ui.showDialog(self.$dialog);
          return

      @initialize = ->
        $container = $(document.body)
        body =
          '<div class="form-group row-fluid">' + '<label>' + '图片' + '</small></label>' +
          '<input class="note-qa-image-url form-control span12" type="file" id="qa-img-file"/>' +
          '<button id="qa-img-rotate">翻转</button>'+
          '<div style="width: 100%;height: 200px;border: 1px dotted gray; overflow: hidden">'+
          '<img id="qa-img-preview" src="" />'+
          '</div>'+
          '<canvas id="image-canvas"   style="display: none"></canvas>' +
          '<div class="progress"><div class="progress-bar" role="progressbar"></div></div>' + '</div>'
        footer = '<button href="#" class="btn btn-primary note-qa-image-btn disabled" disabled>' + '上传图片' + '</button>'

        @$dialog = ui.dialog({
          body: body,
          footer: footer,
          class: 'note-qa-image-dialog'
        }).render()

        @$dialog.appendTo('body');

        return

      return
  )

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

readURL = (input) ->
  if input.files and input.files[0]
    reader = new FileReader

    reader.onload = (e) ->
      image = new Image();
      image.src = e.target.result
      image.onload = ->


        $('#qa-img-preview').attr
          'src': e.target.result
          'width': 200
          'height': 200
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
