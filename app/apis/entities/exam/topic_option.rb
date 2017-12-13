module Entities
  module Exam
    class TopicOption < Grape::Entity
      expose :id
      expose :topic_id
      expose :name
      expose :title
      expose :correct
      expose :created_at
      expose :updated_at
    end
  end
end
