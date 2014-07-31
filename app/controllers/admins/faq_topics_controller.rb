class Admins::FaqTopicsController < ApplicationController
  layout "admin_home"

  def show
    @faq_topic = FaqTopic.find(params[:id])
    @faqs = @faq_topic.faqs
  end

  def index
    @faq_topics = FaqTopic.all
  end

end