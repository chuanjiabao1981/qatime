module TopicsList
  extend ActiveSupport::Concern

  def get_topics(lesson)
    Topic.where(lesson_id: lesson.id).order(created_at: :desc).paginate(page: params[:page],:per_page => 10) if lesson
  end
end