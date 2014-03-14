class CommentsController < ApplicationController
  def create
    @tutorial = Tutorial.find(params[:tutorial_id])
    @comment  = @tutorial.comments.build(params[:comment].permit!)
    @comment.author = current_user
    if @comment.save
      redirect_to cpanel_tutorial_url @tutorial
    end
  end
end
