class FaqsController < ApplicationController
  layout :resolve_layout

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
    @faqs = Faq.all
  end

  def show
    @faq        = Faq.find(params[:id])
  end


  def destroy
    @faq = Faq.find(params[:id])
    @faq.destroy
    redirect_to faqs_path
  end

  def edit
    @faq = Faq.find(params[:id])
  end

  private
  def resolve_layout
    case current_user.role
      when "admin"
        "admin_home"
      when "teacher"
        "teacher_home"
      when "student"
        "student_home"
      else
        "application"
    end
  end
end