module Qatime
  class VideoUtil
    def self.capture(url)
      real_url = url.gsub(/^https/, "http")
      filename = real_url.split('/').last
      output = "/tmp/" + filename.downcase.gsub(/\.\w+$/, "-#{Time.now.to_i}.jpg")
      `~/bin/ffmpeg -i #{real_url} -qscale:v 2 -vframes 1 #{output} 2>&1`
      return unless File.exist?(output)
      File.open(output)
    end

    def self.duration(url)
      real_url = url.gsub(/^https/, "http")
      result = `~/bin/ffprobe -i #{real_url} -show_entries format=duration -v quiet -of csv="p=0" 2>&1`
      result.to_i
    end
  end
end
