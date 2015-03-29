class LearningPlansController < ApplicationController
  respond_to :html

  def index
    @learning_plans = LearningPlan.all
  end
  def new
    @student       = Student.find(params[:student_id])
    @learning_plan = @student.learning_plans.build
  end

  def create
    @student       = Student.find(params[:learning_plan][:student_id])
    @learning_plan = @student.learning_plans.build(params[:learning_plan].permit!)
    if @learning_plan.save
      redirect_to learning_plans_path
    else
      render 'new'
    end
  end

  def edit
    @learning_plan = LearningPlan.find(params[:id])
  end

  def update
    @learning_plan = LearningPlan.find(params[:id])
    if @learning_plan.update_attributes(params[:learning_plan].permit!)
      redirect_to learning_plans_path
    else
      render 'edit'
    end

  end

  def teachers
    if params[:id]
      @learning_plan = LearningPlan.find(params[:id])
      @learning_plan.vip_class_id = params[:learning_plan][:vip_class_id]
    else
      @learning_plan = LearningPlan.new(params[:learning_plan].permit!)
    end
  end
end
