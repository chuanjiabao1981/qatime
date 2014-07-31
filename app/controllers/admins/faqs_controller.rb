class Admins::FaqsController < ApplicationController
  layout "admin_home"
  respond_to :html

  def new
    @faq = Faq.new_with_token
  end

  def create
    @faq_topic = FaqTopic.find(params[:faq_topic_id])
    @faq = @faq_topic.faqs.build(params[:faq].permit!)
    @faq.user = current_user
    @faq.save
    respond_with :admins,@faq
  end

  def index
    @teacher_faq_topics = FaqTopic.where(user_type: "teacher")
    @student_faq_topics = FaqTopic.where(user_type: "student")
    respond_with :admins,@teacher_faq_topics, @student_faq_topics
  end

  def show
    @faq = Faq.find(params[:id])
  end


  def destroy
    @faq = Faq.find(params[:id])
    @faq.destroy
    redirect_to admin_faqs_path
  end

  def edit
    @faq = Faq.find(params[:id])
  end

end