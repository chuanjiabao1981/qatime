class QaFaqsController < ApplicationController
  respond_to :html

  def index
    @qa_faqs = QaFaq.order(:created_at)
    @qa_faqs = @qa_faqs.common_teacher if current_user.try(:teacher?)
    @qa_faqs = @qa_faqs.common_student if current_user.try(:student?)
    render layout: 'v1/qa_faq'
  end

  def new
    @qa_faq = QaFaq.new
    @qa_faq.generate_token if @qa_faq.token.nil?
  end

  def create
    @qa_faq = QaFaq.new(params[:qa_faq].permit!)
    @qa_faq.save
    respond_with @qa_faq
  end

  def show
    render layout: 'v1/qa_faq'
  end

  def edit
    @qa_faq = QaFaq.find(params[:id])
  end

  def update
    @qa_faq = QaFaq.find(params[:id])
    @qa_faq.update_attributes(params[:qa_faq].permit!)
    respond_with @qa_faq
  end

  def courses
    render layout: 'v1/qa_faq'
  end

  def teacher
    render layout: 'v1/qa_faq'
  end

  def student
    render layout: 'v1/qa_faq'
  end

  def user_agreements
    if %w[student teacher].include?(params[:cate])
      render template: "qa_faqs/user_agreements/#{params[:cate]}", layout: 'v1/qa_faq'
    else
      render layout: 'v1/qa_faq'
    end
  end

  private

  def current_resource
    @qa_faq = QaFaq.find(params[:id]) if params[:id]
  end
end
