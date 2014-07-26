class FaqTopicsController < ApplicationController
  def show
    @faq_topic = FaqTopic.find(params[:id])
  end
end
