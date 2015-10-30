class CommentsController < ApplicationController
  respond_to :js

  def create
    @commentable    = params[:commentable_type].constantize.find(params[:commentable_id])
    @comment        = @commentable.comments.build(params[:comment].permit!)
    @comment.author = current_user
    if @comment.save
      @comment.notify
      respond_with @comment
    else
      render 'new'
    end
  end
  def edit

  end

  def update
    if @comment.update_attributes(params[:comment].permit!)
      respond_with @comment
    else
      render 'edit'
    end

  end
  def destroy
    @comment.destroy
  end
  private
  def current_resource
    @comment = Comment.find(params[:id]) if params[:id]
  end
end
