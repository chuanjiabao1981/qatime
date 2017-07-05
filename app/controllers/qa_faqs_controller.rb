class QaFaqsController < ApplicationController
  respond_to :html
  before_action :find_faq, only: [:edit, :update, :static_page, :agreement, :teacher_usage, :student_usage]

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
    when 'teacher_usage'
      redirect_to action: :teacher_usage, id: @qa_faq
    when 'student_usage'
      redirect_to action: :student_usage, id: @qa_faq
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
  end

  def update
    @qa_faq.update_attributes(params[:qa_faq].permit!)

    case @qa_faq.show_type
    when 'agreement'
      redirect_to action: :agreement, id: @qa_faq
    when 'teacher_usage'
      redirect_to action: :teacher_usage, id: @qa_faq
    when 'student_usage'
      redirect_to action: :student_usage, id: @qa_faq
    when 'static_page'
      redirect_to action: :static_page, id: @qa_faq
    else
      redirect_to action: :show, id: @qa_faq
    end
  end

  def static_page
    render layout: 'v1/qa_faq'
  end

  def teacher_usages
    @qa_faqs = QaFaq.teacher_usage.order(:position)
    render layout: 'v1/qa_faq'
  end

  def teacher_usage
    render layout: 'v1/qa_faq'
  end

  def student_usages
    @qa_faqs = QaFaq.student_usage.order(:position)
    render layout: 'v1/qa_faq'
  end

  def student_usage
    render layout: 'v1/qa_faq'
  end

  def agreements
    @qa_faqs = QaFaq.agreement.order(:position)
    render layout: 'v1/qa_faq'
  end

  def agreement
    render layout: 'v1/qa_faq'
  end

  private

  def find_faq
    @qa_faq = QaFaq.find(params[:id])
  end

  def current_resource
    @qa_faq = QaFaq.find(params[:id]) if params[:id]
  end
end
