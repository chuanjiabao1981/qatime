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
            begin
              code = 500
              if params[:beginTime].blank? # 视频合并结果
                replay = ::LiveStudio::Replay.find_by(name: params[:video_name])
                code = 200 if replay && replay.merge_callback(params)
              elsif params['video_name'].include?('camera') # 摄像头录制不处理
                code = 200
              else # 白板录制视频
                channel = ::LiveStudio::Channel.find_by(remote_id: params[:cid])
                lesson_id = params['video_name'].split('_').find{|x| x.include?('board')}.scan(/\d+/).first
                lesson = case channel.channelable_type
                         when 'LiveStudio::Course'
                           channel.channelable.lessons.find(lesson_id)
                         when 'LiveStudio::InteractiveCourse'
                           channel.channelable.interactive_lessons.find(lesson_id)
                         when 'LiveStudio::Group'
                           channel.channelable.scheduled_lessons.find(lesson_id)
                         else
                           channel.channelable.lessons.find(lesson_id)
                         end
                lesson.instance_videos(channel, params)
                code = 200
              end
            rescue StandardError => e
              Rails.logger.error "#{e.message}\n\n#{e.backtrace.join("\n")}"
              Rails.logger.info params
            end
            {
                code: code
            }
          end

          desc '音视频回调接口'
          params do
            optional :eventType
            optional :fileinfo
          end
          post 'im_callback' do
            status 200
            Rails.logger.info "im_callback start......................."
            Rails.logger.info params
            begin
              code = 500
              if params[:eventType].to_s == '6'
                res = JSON.parse(params[:fileinfo])[0]
                channel_video = ::LiveStudio::ChannelVideo.find_by(channelid: res['channelid'])
                code = 200 if channel_video && channel_video.merge_callback(res)
              end
            rescue StandardError => e
              Rails.logger.error "#{e.message}\n\n#{e.backtrace.join("\n")}"
              Rails.logger.info params
            end
            {
                code: code
            }
          end

          desc '转码回调接口'
          params do
            optional :type
          end
          post 'transcode_callback' do
            Rails.logger.info "transcode_callback start......................."
            Rails.logger.info params
            channel_video = ::LiveStudio::ChannelVideo.find_by(vid: params[:vid])
            channel_video.transcode_callback
          end
        end
      end
    end
  end
end
