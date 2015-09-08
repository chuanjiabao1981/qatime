class QuestionsController < ApplicationController

  layout  "vip"
  respond_to :html,:js
  def index
    @questions = Question.all.includes({learning_plan: :teachers},:vip_class,:student).order("created_at desc").paginate(page: params[:page],:per_page => 10)

  end

  def new
    @student   = current_user
    @question  = Question.new
    @question.generate_token if @question.token.nil?
    __init_params
  end

  def create
    @student    = current_user

    @question   = current_user.questions.build(params[:question].permit!)
     if @question.save
       flash[:success] = "成功创建#{Question.model_name.human}"
       SmsWorker.perform_async(SmsWorker::QUESTION_CREATE_NOTIFICATION, id: @question.id)
     else
       __init_params
     end
    respond_with @question
  end

  def edit
    @student   = @question.student
    @teachers  = @question.learning_plan.teachers
  end
  def update
    @student   = @question.student

    if @question.update_attributes(params[:question].permit!)
      ## 简单起见，每次都更新vip_class
      @question.vip_class = @question.learning_plan.vip_class
      @question.save
      flash[:success] = "成功编辑#{Question.model_name.human}"
      SmsWorker.perform_async(SmsWorker::QUESTION_CREATE_NOTIFICATION, id: @question.id)
    else
      __init_params
    end
    respond_with @question
  end
  def show
    @answer = @question.build_a_answer(nil,{})
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  def student
    @questions = Question.all.where("student_id=?",current_user.id).
                              includes({learning_plan: :teachers},:vip_class,:student).
                              order("created_at desc").paginate(page: params[:page],:per_page => 10)
  end
  def teacher
    # @questions = Question.all.by_learning_plan(params[:learning_plan_id])
    #                     .by_teacher(params[:teacher_id])
    #                     .includes({learning_plan: :teachers},:vip_class,:student)
    teacher = Teacher.find(params[:teacher_id])
    @questions = teacher.questions.order("created_at desc").paginate(page: params[:page],:per_page => 10)
  end

  def teachers
    learning_plan = LearningPlan.find(params[:learning_plan_id])
    @question     = Question.new
    @teachers     = learning_plan.teachers
  end
  private
  def __init_params
    #设置learning_plan
    @question.init_learning_plan(@student)
    if @question.learning_plan
      @teachers  = @question.learning_plan.teachers
    end
    @teachers = [] unless @teachers

  end
  def current_resource
    if params[:id]
      @question  = Question.find(params[:id]) if params[:id]
    elsif params[:question] and params[:question][:learning_plan_id] and not params[:question][:learning_plan_id].empty?
      ## 这个只有create的时候才会走到此分支
      @learning_plan = LearningPlan.find(params[:question][:learning_plan_id])
    end
  end

end
