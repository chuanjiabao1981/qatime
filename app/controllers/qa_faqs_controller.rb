class QaFaqsController < ApplicationController
  respond_to :html

  def index
    @qa_faqs = QaFaq.faq.order(:created_at)
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
    case @qa_faq.show_type
    when 'agreement'
      redirect_to action: :agreement, id: @qa_faq
    when 'static_page'
      redirect_to action: :static_page, id: @qa_faq
    else
      redirect_to action: :show, id: @qa_faq
    end
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

    case @qa_faq.show_type
    when 'agreement'
      redirect_to action: :agreement, id: @qa_faq
    when 'static_page'
      redirect_to action: :static_page, id: @qa_faq
    else
      redirect_to action: :show, id: @qa_faq
    end
  end

  def static_page
    @qa_faq = QaFaq.find(params[:id])
    render layout: 'v1/qa_faq'
  end

  def agreements
    @qa_faqs = QaFaq.agreement.order(:position)
    render layout: 'v1/qa_faq'
  end

  def agreement
    @qa_faq = QaFaq.find(params[:id])
    render layout: 'v1/qa_faq'
  end

  private

  def current_resource
    @qa_faq = QaFaq.find(params[:id]) if params[:id]
  end
end
