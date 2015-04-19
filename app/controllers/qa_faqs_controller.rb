class QaFaqsController < ApplicationController
  respond_to :html

  def index
    @qa_faqs = QaFaq.all
  end

  def new
    @qa_faq = QaFaq.new
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
    @qa_faq.update_attributes(params[:qa_fap].permit!)
    respond_with @qa_faq
  end
end
