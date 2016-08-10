class Students::FaqTopicsController < ApplicationController
  layout 'student_home_new'

  def show
    @faq_topic = FaqTopic.find(params[:id])
    @faqs = @faq_topic.faqs
  end

  def index
    @faq_topics = FaqTopic.all
  end

end
