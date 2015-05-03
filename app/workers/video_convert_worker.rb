require "benchmark"


class VideoConvertWorker
=begin
  此类负责把video进行转化，并把转化好的视频写回数据库
=end

  include Sidekiq::Worker
  sidekiq_options :queue => :video_convert, :retry => false, :backtrace => true


  def perform(id,after_convert_sleep=0)
    begin
      video                   = get_video(id)
      convert_video_path_name = convert_video(video)
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
  def get_video(id)
    Video.transaction do
      video = Video.lock.find(id)
      video.fire_events!(:convert_process_begin)
      video.save!
      video
    end
  end
  def convert_video(video)
    convert_video_path_name = "/tmp/#{video.build_convert_file_name}"
    #%x 获取不了stderr，所以这里进行了重定向
    result = %x(ffmpeg -y -i #{video.name} -vcodec h264 -acodec aac -strict -2 #{convert_video_path_name} 2>&1)
    if ($?.exitstatus == 0)
      convert_video_path_name
    else
      raise StandardError,result
    end
  end

  def save_video(video,convert_video_path_name)
    File.open(convert_video_path_name) do |f|
      video.convert_name = f
    end
    #存储视频到aliyun 避免在加锁的时候进行上传文件
    video.store_convert_name!

    update_video_info video do |video|
      video.fire_events!(:convert_process_finish)
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