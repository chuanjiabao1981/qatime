module Entities
  module Exam
    class Topic < Grape::Entity
      expose :id
      expose :paper_id
      expose :category_id
      expose :package_topic_id
      expose :group_topic_id
      expose :name
      expose :section_name
      expose :title
      expose :attach
      expose :topics_count
      expose :duration
      expose :score
      expose :read_time
      expose :play_times
      expose :interval_time
      expose :waiting_time
      expose :answer
      expose :answer_attach
      expose :type
      expose :status
      expose :topics, using: Entities::Exam::Topic
      expose :topic_options, using: Entities::Exam::TopicOption
      expose :created_at
      expose :updated_at
    end
  end
end
