module LiveStudio
  module PlayRecordWithJob
    # 记录播放记录
    def instance_play_records(immediately = false)
      return super if immediately
      ::LiveStudio::LessonPlayRecordJob.perform_later(id, model_name.to_s)
    end
  end
end
