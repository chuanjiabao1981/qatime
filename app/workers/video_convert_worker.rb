class VideoConvertWorker
  include Sidekiq::Worker
  def perform(id)
    puts id
    puts "we are work..............."
    convert_name = "/tmp/xxxxxxxx-x264.mp4"
    video = Video.find(id)
    puts video.name
    result = %x(ffmpeg -i #{video.name} -vcodec h264 -acodec aac -strict -2 #{convert_name})

    File.open(convert_name) do |f|
      video.convert_name = f
    end
    video.save!;
    puts $?.exitstatus
    puts result
    puts "xxxxxx"
  end
end