class MessageBoardsController < ApplicationController
  layout "application"

  def show

  end

  private
  def current_resource
    if params[:id]
      @message_board = MessageBoard.find(params[:id])
    end
  end
end
