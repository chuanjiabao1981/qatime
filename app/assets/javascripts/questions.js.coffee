sumitPicture = (token,pictureType,pictureFile)->
  deferredPictureUpload = $.Deferred()
  pictureForm = """
    <form id="pictures_upload" action="/pictures" enctype="multipart/form-data" method="post">
    </form>
  """
  picutreFormData = new FormData
  picutreFormData.append "picture[token]", token
  picutreFormData.append "picture[name]" , pictureFile
  picutreFormData.append "picture[imageable_type]", pictureType
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

$(document).ready ->
  $('[data-provider="summernote-question"]').each ->
    $progress     = $('.progress');
    $progress_bar = $('.progress-bar');

    $(this).summernote
      lang: 'zh-CN',
      height: 400
      onImageUpload: (files, editor, welEditable) ->
        sumitPicture($('div#qa_question_params').data('token'),
                     $('div#qa_question_params').data('picture-type'),
                     files[0]).done((url)->
          editor.insertImage(welEditable, url);
        ).progress((percent)->
          $progress.show()
          $progress_bar.css({width: percent})
          $progress_bar.text(percent)
          if percent == '100%'
            $progress_bar.text("图像上传完毕")
            $progress.hide('slow')
        )