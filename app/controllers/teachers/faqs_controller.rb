class Teachers::FaqsController < ApplicationController
  layout "teacher_home"

  def index
    @faqs = Faq.where(is_top: "1", faq_type:"老师")
    @faq_topics = FaqTopic.where(user_type: "teacher")
  end

  def show
    @faq = Faq.find(params[:id])
  end

end