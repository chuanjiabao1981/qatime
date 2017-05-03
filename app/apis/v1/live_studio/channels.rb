module V1
  # 辅导班接口
  module LiveStudio
    class Channels < V1::Base
      namespace "live_studio" do
        resource :channels do
          desc '云视频回调接口'
          params do
            optional :vid
            optional :video_name
            optional :orig_video_key
            optional :uid
            optional :cid
            optional :beginTime
            optional :endTime
            optional :nId
          end
          post 'callback' do
            code = 500
            if params[:beginTime].present?
              channel = ::LiveStudio::Channel.find_by(remote_id: params[:cid])
              lesson_id = params['video_name'].split('_').first.gsub(/lessons(\d+)board/, '\\1')
              lesson = ::LiveStudio::Lesson.where(course_id: channel.course_id).find(lesson_id)
              result = lesson.channel_videos.create(
                name: params['video_name'],
                vid: params['vid'],
                begin_time: params['beginTime'],
                end_time: params['endTime'],
                channel_id: channel.id,
                video_for: channel.use_for) if lesson && lesson.channel_videos.find_by(vid: params['vid']).nil?
              code = 200 if result
            else
              replay = ::LiveStudio::Replay.find_by(name: params[:video_name])
              if replay && replay.update(vid: params['vid'],
                               orig_video_key: params[:orig_video_key],
                               uid: params[:uid],
                               n_id: params[:nID])
                replay.video_get
                replay.merged!
                replay.lesson.merged!
                code = 200
              end
            end
            {
              code: code
            }
          end
        end
      end
    end
  end
end
