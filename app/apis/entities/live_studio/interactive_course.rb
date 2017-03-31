module Entities
  module LiveStudio
    class InteractiveCourse < Grape::Entity
      format_with(:local_timestamp, &:to_i)
      expose :id
      expose :name
      expose :subject
      expose :grade
      expose :price
      expose :status
      expose :description
      expose :lessons_count
      expose :completed_lessons_count
      expose :closed_lessons_count
      expose :live_start_time
      expose :live_end_time
      expose :objective
      expose :suit_crowd
      expose :publicize_url
      expose :publicize_info_url do |course|
        course.publicize_url(:info)
      end
      expose :publicize_list_url do |course|
        course.publicize_url(:list)
      end
      expose :publicize_app_url do |course|
        course.publicize_url(:app_info)
      end
      expose :chat_team, using: Entities::Chat::Team, if: { type: :full }
      expose :interactive_lessons, using: Entities::LiveStudio::InteractiveLesson, if: { type: :full }

      with_options(format_with: :local_timestamp) do
        expose :created_at
      end
    end
  end
end