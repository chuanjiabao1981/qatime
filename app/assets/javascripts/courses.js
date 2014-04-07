$(
  function(){
    var cover_input         = $("input#cover_name");
    var cover_form          = cover_input.closest('form');
    var cover_show          = $("div#cover_show");

//    console.log($("div#cover_show img").length);
    if ($("div#cover_show img").length == 0){
        cover_show.html($("div#template-progress div.progress").clone());
    }

    cover_input.on('change',function(){
        cover_form.ajaxSubmit({
            dataType: 'json',
            beforeSubmit: function(formData, jqForm, options)
            {
                cover_show.html($("div#template-progress div.progress").clone());
            },
            success: function(responseText, statusText, xhr, $form)
            {
//                alert(responseText);
//                alert(statusText);
                var url = responseText.name.big.url;
                cover_show.html('<img src='+url+'/>');
            },
            uploadProgress: function(event, position, total, percentComplete) {
                var percentVal              = percentComplete + '%';
                var cover_progress_bar      = $("div#cover_show div.progress-bar");
                console.log(cover_progress_bar.size());
                cover_progress_bar.text(percentVal);
                cover_progress_bar.css({width:percentVal});
                if (percentVal == '100%'){
//                    cover_progress_bar.hide("slow");
                }
            }
        });
    });

  }
)