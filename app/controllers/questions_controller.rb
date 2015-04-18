class QuestionsController < ApplicationController

  layout  "vip"
  respond_to :html
  def index
    @questions = Question.all.includes({learning_plan: :teachers},:vip_class,:student).order("created_at desc").paginate(page: params[:page],:per_page => 10)

  end

  def new
    @student   = current_user

    @question = Question.new
    @question.generate_token if @question.token.nil?

  end

  def create
    @student    = current_user

    @question   = current_user.questions.build(params[:question].permit!)
    flash[:success] = "成功创建#{Question.model_name.human}"  if @question.save
    respond_with @question
  end

  def edit
    @student   = @question.student
  end
  def update
    @student   = @question.student
    @question.update_all_infos(params[:question].permit!)
    respond_with @question
  end
  def show
    @answer = @question.build_a_answer(nil,{})
  end


  def student
    @questions = Question.all.where("student_id=?",current_user.id).
                              includes({learning_plan: :teachers},:vip_class,:student).
                              order("created_at desc").paginate(page: params[:page],:per_page => 10)
  end
  def teacher
    @questions = Question.all.by_learning_plan(params[:learning_plan_id])
                        .by_teacher(params[:teacher_id])
                        .includes({learning_plan: :teachers},:vip_class,:student)
                        .order("created_at desc").paginate(page: params[:page],:per_page => 10)
  end
  private
  def current_resource
    if params[:id]
      @question  = Question.find(params[:id]) if params[:id]
    elsif params[:question] and params[:question][:vip_class_id] and not params[:question][:vip_class_id].empty?
      @vip_class = VipClass.find(params[:question][:vip_class_id])
    else
      "dummy"
    end
  end

end
