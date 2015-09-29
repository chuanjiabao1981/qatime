function video_preview_load() {
    console.log("here");
    source_node = $('source#video_preview_source')
    if(source_node == null || source_node.length == 0) {
        return
    }
    var video_url = source_node.attr("src")

    $("div#course_lesson_detail").html()
    $("div#course_lesson_detail").html('<source src=\"' + video_url + '\" id = \"video_source\" type=\"mp4\" /><source src=\"false\" id = \"buy_status\" /><video id=\"player\"/>')
    video_load()
}

function video_load(player_id)
{
    console.log('Good to go!');

    var player = videojs(player_id, {
                                        "controls": true,
                                        "autoplay": false,
                                        "preload": "auto",
                                        "width": 810,
                                        "height": 375
                                    }, function() {
        //console.log('Good to go!');

//        this.play(); // if you don't trust autoplay for some reason

        // How about an event listener?
        this.on('ended', function() {
            console.log('awww...over so soon?');

        });

    });
}

function video_load_jwplayer(video_width, video_height) {
    video_width = arguments[0] ? arguments[0] : 810;
    video_height = arguments[1] ? arguments[1] : 375;

    source_node = $('source#video_source')
    buy_status_source = $('source#buy_status')

    if(source_node == null || source_node.length == 0) {
        return
    }
    var video_url = source_node.attr("src")
    var video_type = source_node[0].type

    buy_status = "true";

    if(buy_status_source != null && buy_status_source.length > 0) {
        buy_status = buy_status_source.attr("src")
    }

    if("mp4" == video_type) {
        jwplayer("player").setup({
            file:video_url,
            flashplayer:'/assets/jwplayer.flash.swf',
            //provider:'/assets/jwplayer/jwplayer.flash.swf',
            width: video_width,
            height: video_height,
            primary: "flash"
        });
    } else {
        jwplayer("player").setup({
            playlist: [{
                file:video_url,
                provider:'/assets/jwplayer/HLSProvider6.swf',
                type: 'hls'
            }],
            hls_debug : false,
            hls_debug2 : false,
            hls_lowbufferlength : 3,
            hls_minbufferlength : -1,
            hls_maxbufferlength : 60,
            hls_startfromlowestlevel : false,
            hls_seekfromlowestlevel : false,
            hls_live_flushurlcache : false,
            hls_live_seekdurationthreshold : 60,
            hls_seekmode : "ACCURATE",
            hls_fragmentloadmaxretry : -1,
            hls_manifestloadmaxretry : -1,
            hls_capleveltostage : false,
            width: video_width,
            height: video_height,
            primary: "flash"
        });
    }
    jwplayer("player").onTime(function(evt){
        currentTime = evt.position.toFixed(1);
        console.log(currentTime);
        //if(currentTime >= 60.1 && buy_status == "false") {
        //    $('div#course_lesson_detail').html($("div#template-v_content div.v_content").clone());
        //}
    });
}

$(
    function video_init()
    {
        console.log("here");
        if ($('video#qa_video_player').size() !=0){
            video_load("qa_video_player");
        }

        var videos = document.getElementsByTagName("video");
        for(var i=0; i<videos.length;i++){
            $(videos[i]).bind('contextmenu',function() { return false; });
        }

    }
);
