module ManagersHelper
  def create_or_update_url(message)
    if message.new_record?
      message_board_messages_path(message.message_board.id)
    else
      message_board_message_path(message.message_board.id,message.id)
    end
  end
end
