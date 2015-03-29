class LearningPlansController < ApplicationController
  respond_to :html

  def index
    @learning_plans = LearningPlan.all
  end
  def new
    @student       = Student.find(params[:student_id])
    @learning_plan = @student.learning_plans.build
    @vip_class     = VipClass.find(1)
    @teachers      = Teacher.by_vip_class(@vip_class)
  end

  def create
    @student       = Student.find(params[:learning_plan][:student_id])
    @learning_plan = @student.learning_plans.build(params[:learning_plan].permit!)
    if @learning_plan.save
      redirect_to learning_plans_path
    else
      @vip_class   = VipClass.find(params[:learning_plan][:vip_class_id])
      @teachers      = Teacher.by_vip_class(@vip_class)
      logger.info @learning_plan.errors.full_messages
      render 'new'
    end
  end

  def teachers
    @vip_class = VipClass.find(params[:learning_plan][:vip_class_id])
    @learning_plan = LearningPlan.new
    @teachers      = Teacher.by_vip_class(@vip_class)
    @teachers = Teacher.by_subject(@vip_class.subject).by_category(@vip_class.category)
  end
end
