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
end
