class WechatVoiceConvertWorker
  def perform(media_id)
    #下载音频文件
    arm_file = Wechat.api.media media_id
    
    convert_voice_path_name = "/tmp/#{SecureRandom.hex}.mp3"
    result = %x(~/bin/ffmpeg -i #{arm_file.path} -ar 22050 2>&1 #{convert_voice_path_name})
    uploader = QaFileUploader.new
    File.open(convert_voice_path_name) do |file|
      uploader.store!(file)
    end
    uploader.url
  end
end
