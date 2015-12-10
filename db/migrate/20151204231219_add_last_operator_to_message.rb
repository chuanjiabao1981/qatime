class AddLastOperatorToMessage < ActiveRecord::Migration
  def change
    add_column :customized_course_messages,:last_operator_id,:integer

  end
end
