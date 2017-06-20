class Admins::CourseIntrosController < ApplicationController
  respond_to :html
  before_action :find_course_intro, only: [:edit, :update, :destroy, :change_status]

  def index
    @course_intros = CourseIntro.order(created_at: :desc).paginate(page: params[:page])
  end

  def new
    @course_intro = CourseIntro.new
  end

  def create
    @course_intro = CourseIntro.new(course_intro_params)
    if @course_intro.save
      redirect_to admins_course_intros_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @course_intro.update(course_intro_params)
      redirect_to admins_course_intros_path
    else
      render :edit
    end
  end

  def destroy
    @course_intro.destroy
    redirect_to admins_course_intros_path
  end

  def change_status
    if @course_intro.stopping?
      CourseIntro.running.map(&:stop!)
      @course_intro.run!
    else
      @course_intro.stop!
    end
    redirect_to admins_course_intros_path
  end

  private

  def find_course_intro
    @course_intro = CourseIntro.find(params[:id])
  end

  def course_intro_params
    params.require(:course_intro).permit(:title, :video_id)
  end
end
