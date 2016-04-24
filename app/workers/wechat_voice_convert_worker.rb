class WechatVoiceConvertWorker
  include Sidekiq::Worker

  def perform(voice_id)
    voice = Message::WechatVoiceMessage.find(voice_id)

    #下载音频文件
    arm_file = Wechat.api.media voice.name

    convert_voice_path_name = "/tmp/#{SecureRandom.hex}.mp3"
    result = system("~/bin/ffmpeg -i #{arm_file.path} -ar 22050 2>&1 #{convert_voice_path_name}")

    if ($?.exitstatus == 0)
      #转换成功
      uploader = QaFileUploader.new
      File.open(convert_voice_path_name) do |file|
        uploader.store!(file)
      end
      oss_url = uploader.url

      duration = get_voice_duration(convert_voice_path_name)

      voice.name = oss_url
      voice.duration = duration
      voice.save
      voice.reload
      
      voice.convert_process_finish!
    else
      voice.convert_process_exec_error!
    end

  end

  def get_voice_duration(file_path)
    duration = `~/bin/ffprobe -i '#{file_path}' -show_entries format=duration -v quiet -of csv="p=0"`
    duration.to_i
  end

end
