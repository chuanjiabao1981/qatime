class Admins::TeachingProgramsController < ApplicationController
  respond_to :html
  layout "admin_home"

  def index
    @teaching_programs = TeachingProgram.all.order(:created_at)
  end

  def new
    @teaching_program         = TeachingProgram.new
    @teaching_program.content = '{"chapters":["章节"]}'
  end

  def create
    @teaching_program = TeachingProgram.new(params[:teaching_program].permit!)
    @teaching_program.save

    respond_with :admins,@teaching_program
  end

  def edit
    @teaching_program = TeachingProgram.find(params[:id])
  end

  def update
    @teaching_program = TeachingProgram.find(params[:id])
    @teaching_program.update_attributes(params[:teaching_program].permit!)
    respond_with :admins,@teaching_program
  end

  def show
    @teaching_program = TeachingProgram.find(params[:id])
  end
end
