module TopicsList
  extend ActiveSupport::Concern

  def get_topics(lesson)
    Topic.where(topicable_id: lesson.id).where(topicable_type: lesson.class.to_s).order(created_at: :desc).paginate(page: params[:page],:per_page => 10) if lesson
  end
end