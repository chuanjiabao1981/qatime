module Entities
  module Resource
    class VideoQuote < Entities::Resource::File
      expose :id
      expose :ext_name, as: :video_type
      expose :duration do |quote|
        quote.file.video_duration
      end
      expose :tmp_duration do |quote|
        quote.file.video_duration
      end
      expose :format_tmp_duration do |quote|
        quote.file.video_format_duration
      end
      expose :capture do |quote|
        quote.file.video_capture_url
      end
      expose :file_url, as: :name_url
    end
  end
end
