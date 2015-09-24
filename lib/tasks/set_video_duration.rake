task :set_video_duration => :environment do
  Video.all.each do |video|
    if video.duration.nil? or video.duration < 0

      if not video.author.nil?
        duration = -1
        duration_calc_result = %x(~/bin/ffprobe -i #{video.name} -show_format -v quiet | sed -n 's/duration=//p')

        if ($?.exitstatus == 0)
          duration = duration_calc_result.to_f.round
        else
          error_message = video.id.to_s + " get durition failed."
          SmsWorker.perform_async(SmsWorker::SYSTEM_ALARM, error_message: error_message)
        end

        if (duration != -1)
          video.duration = duration
          video.save!
        end
      end
    end
  end
end