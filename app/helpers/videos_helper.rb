module VideosHelper
  def video_player *args
    options = { width: 320,
                height: 180,
                class: 'video-js vjs-default-skin vjs-big-play-centered video-center',
               }.merge args.extract_options!
    src = options.delete(:src) || {}
    content_tag :video, options do
      raw src.map { |type, url| raw tag(:source, src: url, type: "video/#{type}") }.join('')
    end
  end

  def video_jwplayer *args
    options = { hls_debug: false,
                hls_debug2: false,
                hls_lowbufferlength: 3,
                hls_minbufferlength: -1,
                hls_maxbufferlength: 60,
                hls_startfromlowestlevel: false,
                hls_seekfromlowestlevel: false,
                hls_live_flushurlcache: false,
                hls_live_seekdurationthreshold: 60,
                hls_seekmode: "ACCURATE",
                hls_fragmentloadmaxretry: -1,
                hls_manifestloadmaxretry: -1,
                hls_capleveltostage: false,
                width: 640,
                height: 480,
                primary: "flash",
    }.merge args.extract_options!

    jwplayer("container").setup({ autostart: true, controlbar: "none", file: "/videos/video.mp4", duration: 57, flashplayer: "/jwplayer/player.swf", volume: 80, width: 720 });
  end

end