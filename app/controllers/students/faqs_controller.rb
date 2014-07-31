class Students::FaqsController < ApplicationController
  layout "student_home"

  def new
    @faq = Faq.new_with_token
  end

  def create
    @faq = Faq.new_with_token(params[:faq].permit!)
    @faq.user = current_user
    @faq.save
    redirect_to faqs_path
  end

  def index
    @faqs = Faq.where(is_top: "1", faq_type:"学生")
    @faq_topics = FaqTopic.where(user_type: "student")
  end

  def show
    @faq = Faq.find(params[:id])
  end


  def destroy
    @faq = Faq.find(params[:id])
    @faq.destroy
    redirect_to faqs_path
  end

  def edit
    @faq = Faq.find(params[:id])
  end

end