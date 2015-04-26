class CommentsController < ApplicationController
  respond_to :js

  def create
    @comment = current_user.comments.build(params[:comment].permit!)
    @comment
    if @comment.save
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
  private
  def current_resource
    @comment = Comment.find(params[:id]) if params[:id]
  end
end
