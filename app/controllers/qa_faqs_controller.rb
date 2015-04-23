class QaFaqsController < ApplicationController
  respond_to :html

  def index
    @qa_faqs = QaFaq.all.order(:created_at)
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
    @qa_faq = QaFaq.find(params[:id])
  end

  def edit
    @qa_faq = QaFaq.find(params[:id])
  end

  def update
    @qa_faq = QaFaq.find(params[:id])
    @qa_faq.update_attributes(params[:qa_faq].permit!)
    respond_with @qa_faq
  end
end
