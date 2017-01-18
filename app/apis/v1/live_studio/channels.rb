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
            p '================>'
            p params
            p '<================'
            code = 500
            if params[:beginTime].present?
              start_at = Time.at(params[:beginTime].to_f / 1000) - 2.minutes
              end_at = Time.at(params[:endTime].to_f / 1000) + 2.minutes
              lesson = ::LiveStudio::Lesson.where("live_start_at > ? and live_end_at < ?", start_at, end_at)
              channel = ::LiveStudio::Channel.find_by(remote_id: params[:cid])
              result = lesson.channel_videos.create(name: params['video_name'],
                                    # url: params['url'],
                                    vid: params['vid'],
                                    begin_time: params['beginTime'],
                                    end_time: params['endTime'],
                                    channel_id: channel.id,
                                    video_for: channel.use_for) unless channel_videos.find_by(vid: params['vid'])
              code = 200 if result
            else
              replay = ::LiveStudio::Replay.find_by(name: params[:video_name])
              if replay.update(vid: params['vid'],
                            name: params['video_name'],
                            orig_video_key: params[:orig_video_key],
                            uid: params[:uid],
                            n_id: params[:nID])

                replay.merged!
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
