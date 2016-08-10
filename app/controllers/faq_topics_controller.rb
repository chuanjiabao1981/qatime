class FaqTopicsController < ApplicationController
  layout :resolve_layout

  def show
    @faq_topic = FaqTopic.find(params[:id])
    @faqs = @faq_topic.faqs
  end

  def index

  end

  private
  def resolve_layout
    case current_user.role
      when "admin"
        "admin_home"
      when "teacher"
        'teacher_home_new'
      when "student"
        'student_home_new'
    end
  end
end
