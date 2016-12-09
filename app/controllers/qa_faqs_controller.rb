class QaFaqsController < ApplicationController
  respond_to :html

  def index
    @qa_faqs = QaFaq.all.order(:created_at)
    render layout: "application_front"
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
    render layout: "application_front"
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
    render layout: "application_front"
  end

  def teacher
    render layout: "application_front"
  end

  def student
    render layout: "application_front"
  end

  private

  def current_resource
    @qa_faq = QaFaq.find(params[:id]) if params[:id]
  end
end
