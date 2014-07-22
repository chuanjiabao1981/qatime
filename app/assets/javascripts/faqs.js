$(function() {
    summer_note = $('#faq_desc');
    progress     = $('#progress');
    progress_bar = $('#progress-bar');
    progress.hide();
    summer_note.summernote({
        height: 280,
        width: 578,
        lang: 'zh-CN',
        onImageUpload: function(files, editor, welEditable) {
            //console.log('image upload:', files, editor, welEditable);
            //console.log(typeof welEditable);
            var fd = new FormData();
            fd.append("picture[name]", files[0]);
            fd.append("picture[token]",$('input#picture_token').val());
            //var uploadImageForm = $('<form action="/pictures" enctype="multipart/form-data" method="post"></form>');
            var uploadImageForm = $("form#pictures_upload");
            progress.show();
            $(uploadImageForm).ajaxSubmit(
                {
                    formData:fd,
                    dataType:'json',
                    uploadProgress: function(event, position, total, percentComplete) {
                        var percentVal = percentComplete + '%';
                        progress_bar.text(percentVal);
                        progress_bar.css({width:percentVal});
                        if (percentVal == '100%'){
                            progress.hide("slow");
                        }
                    },
                    success: function(responseText, statusText, xhr, $form){
                        var url =responseText.name.url;
                        editor.insertImage(welEditable, url);
                    }
                }
            );
        }
    });
    summer_note.code(summer_note.val());
    return summer_note.closest('form').submit(function() {
        summer_note.val(summer_note.code());
        return true;
    });
});