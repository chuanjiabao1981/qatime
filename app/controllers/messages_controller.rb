class MessagesController < ApplicationController
  layout "application"

  def new
    @message = @message_board.messages.build
  end

  private
  def current_resource
    if params[:message_board_id]
      @message_board = MessageBoard.find(params[:message_board_id])
    end
  end
end
