$(
    function()
    {
        var tutorial_cover_progress         = $("#progress-tutorial-cover-progress");
        var tutorial_cover_progress_bar     = $("#progress-tutorial-cover-progress-bar");
        var tutorial_video_progress         = $("#progress-tutorial-video-progress");
        var tutorial_video_progress_bar     = $("#progress-tutorial-video-progress-bar");
        var tutorial_cover_input            = $("input#cover_name1");
        var tutorial_video_input            = $("input#video_name1");
        var tutorial_show                   = $("div#tutorial-cover");
        tutorial_cover_progress.hide();
        tutorial_video_progress.hide();
        tutorial_cover_input.on('change',function(){
            tutorial_cover_input.closest('form').ajaxSubmit({
                    dataType: 'script',
                    beforeSubmit: function(formData, jqForm, options)
                    {
                        tutorial_cover_progress.show();
                    },
                    success: function(responseText, statusText, xhr, $form){
                        //var url =responseText.name.normal.url;
                        //tutorial_show.append($('<img class="img-thumbnail" src='+url+'/>'));
                    },
                    uploadProgress: function(event, position, total, percentComplete) {
                        var percentVal = percentComplete + '%';
                        tutorial_cover_progress_bar.text(percentVal);
                        tutorial_cover_progress_bar.css({width:percentVal});
                        if (percentVal == '100%'){
                            tutorial_cover_progress.hide("slow");
                        }
                    }
                }
            );
        });
        tutorial_video_input.on('change',function(){
            tutorial_video_input.closest('form').ajaxSubmit({
                dataType: 'script',
                beforeSubmit: function(formData,jgForm,options){
                    tutorial_video_progress.show();
                },
                uploadProgress: function(event, position, total, percentComplete) {
                    var percentVal = percentComplete + '%';
                    tutorial_video_progress_bar.text(percentVal);
                    tutorial_video_progress_bar.css({width:percentVal});
                    if (percentVal == '100%'){
                        tutorial_video_progress.hide("slow");
                    }
                }


            });
        });

    }
)