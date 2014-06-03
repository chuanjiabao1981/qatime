$(
    function(){
        source_node = $('source#video_source')
	    var video_url = source_node.attr("src")
        var video_type = source_node[0].type

        console.log(video_type)
        console.log("-----------" + video_url + "---------------")

        if("mp4" == video_type) {
            jwplayer("player").setup({
                playlist: [{
                    file:video_url
                }],
                width: 640,
                height: 360,
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
                width: 640,
                height: 360,
                primary: "flash"
            });
        }
    }
);