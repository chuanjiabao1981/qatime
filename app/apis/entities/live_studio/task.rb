module Entities
  module LiveStudio
    class Task < Grape::Entity
      format_with(:local_timestamp, &:to_i)

      expose :id
      expose :title
      expose :parent_id
      expose :status
      expose :user_id
      expose :user_name
      expose :course_id
      expose :course_name
      expose :course_model_name

      with_options(format_with: :local_timestamp) do
        expose :created_at
        expose :published_at
        expose :resolved_at
      end
      expose :model_name
    end
  end
end
