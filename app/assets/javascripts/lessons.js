$(
    function(){
        var video_input = $("input#video_name");
        var video_form  = video_input.closest('form');
        var video_show  = $("div#video_show");
        if ($("div#video_show video").length == 0){
            video_show.html($("div#template-progress div.progress").clone());
        }
        video_input.on('change',function(){
            video_form.ajaxSubmit({
                dataType: 'script',
                beforeSubmit: function(){
                    video_show.html($("div#template-progress div.progress").clone());
                },
                uploadProgress: function(event, position, total, percentComplete) {
                    var percentVal              = percentComplete + '%';
                    var video_progress_bar      = $("div#video_show div.progress-bar");
//                    console.log(cover_progress_bar.size());
                    video_progress_bar.text(percentVal);
                    video_progress_bar.css({width:percentVal});
                    if (percentVal == '100%'){
//                    cover_progress_bar.hide("slow");
                    }
                }
            });
        })
    }
)

$(
    function(){
        $("div.lesson_item a").tooltip();
    }
)