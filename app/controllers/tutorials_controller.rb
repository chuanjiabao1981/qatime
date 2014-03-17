class TutorialsController < ApplicationController

  def index
    @tutorials = Tutorial.all
    #render layout:'application_one_col'
  end

  def show
    @tutorial = Tutorial.find(params[:id])
    @comment  = @tutorial.comments.build
  end

  def destroy
    @tutorial = Tutorial.find(params[:id])
    @tutorial.destroy
    redirect_to tutorials_path
  end

end
