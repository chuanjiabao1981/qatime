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
            p params
            # channel_video = LiveStudio::ChannelVideo.find_or_create_by(nid: params[:nId], vid: params[:vid])
            # begin_time = Time.at(params[:beginTime].to_i).to_s(:db)
            # end_time = Time.at(params[:endTime].to_i).to_s(:db)
            # lesson = channel_video.channel.course.lessons.find_by(live_start_at: begin_time, live_end_at: end_time)
            # channel_video.update(name: params[:video_name], key: params[:orig_video_key], lesson_id: lesson.id)
            # {
            #   code: 200
            # }
          end
        end
      end
    end
  end
end
