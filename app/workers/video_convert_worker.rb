require "benchmark"


class VideoConvertWorker
=begin
  此类负责把video进行转化，并把转化好的视频写回数据库
=end

  include Sidekiq::Worker
  sidekiq_options :queue => :video_convert, :retry => false, :backtrace => true


  def perform(id,after_convert_sleep=0,video_class="Video")
    begin
      video                   = get_video(video_class,id)


      convert_video_path_name, duration = convert_video(video)

      sleep after_convert_sleep
      save_video(video,convert_video_path_name)

    rescue VideoChangedWhenConvertingException
      ## 如果视频发生变化，只要抛出异常就好了
      raise
    rescue Exception => e
      if video
        begin
          update_video_info video do
            video.fire_events(:convert_process_exec_error)
            video.save!
          end
        rescue VideoChangedWhenConvertingException
          ## 这里啥都别做了
        end
      end
      raise e
    end

  end

  private

=begin
  标记并返回要进行转化的视频
=end
  def get_video(video_class,id)
    video_class.constantize.transaction do
      video = video_class.constantize.lock.find(id)
      video.fire_events!(:convert_process_begin)
      video.save!
      video
    end
  end
  def convert_video(video)
    convert_video_path_name = "/tmp/#{video.build_convert_file_name}"
    #%x 获取不了stderr，所以这里进行了重定向
    #result = %x(wget #{video.name} -O /tmp/#{video.name_identifier})

    #第一步，先把header移动到视频头部

    result = %x(/usr/local/bin/qtfaststart #{self.current_path} 2>&1)
    if ($?.exitstatus != 0)
      error_message = video.id + " qtfaststart failed."
      SmsWorker.perform_async(SmsWorker::SYSTEM_ALARM, error_message)
      # 这里通过短信报警，发送给相关owner，提示一下即可，不需要block住整个转码的过程

    end

    result = %x(~/bin/ffmpeg -y -i #{video.name} -vcodec h264 -acodec aac -strict -2 #{convert_video_path_name} 2>&1)
    Rails.logger.info result
    if ($?.exitstatus == 0)
      #对于转码成功的，获取其视频时长并返回
      #对于duration没计算出来的，要不要输入一个默认值，如果出错，先爆出来
      duration = -1
      duration_calc_result = %x(~/bin/ffprobe -i #{convert_video_path_name} -show_format -v quiet | sed -n 's/duration=//p'')

      if ($?.exitstatus == 0)
        duration = duration_calc_result.to_f.round
      else
        error_message = video.id + " get durition failed."
        SmsWorker.perform_async(SmsWorker::SYSTEM_ALARM, error_message)
      end

      [convert_video_path_name, duration]
    else
      #这里需要增加报警
      error_message = video.id + " convert failed."
      SmsWorker.perform_async(SmsWorker::SYSTEM_ALARM, error_message)
      raise StandardError,result
    end
  end

  def save_video(video,convert_video_path_name, duration)
    File.open(convert_video_path_name) do |f|
      video.convert_name = f
    end
    #存储视频到aliyun 避免在加锁的时候进行上传文件
    video.store_convert_name!

    update_video_info video do |video|
      video.fire_events!(:convert_process_finish)
      video.duration = duration
      video.save!
    end

  end



  def update_video_info(converting_video,&b)
    converting_video.class.transaction do
      video_now = converting_video.class.lock.find(converting_video.id)
      # 如果视频发生变化，直接返回不再进行任何操作
      # 状态（state）由改变视频方 负责修改。
      # 注意这里需要video_now的原因是 converting_video.reload 对name字段不起作用。
      if video_now.name.identifier != converting_video.name.identifier or video_now.state != converting_video.state
        # 这里不必删除 converting_video.convert_name
        # 因为老的在覆盖的时候删除。
        raise VideoChangedWhenConvertingException  , "Old  #{converting_video.to_json} ,new  #{video_now.to_json}"
      end
      yield converting_video
    end
  end
end