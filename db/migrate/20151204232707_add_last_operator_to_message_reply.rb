class AddLastOperatorToMessageReply < ActiveRecord::Migration
  def change
    add_column :customized_course_message_replies,:last_operator_id,:integer
  end
end
