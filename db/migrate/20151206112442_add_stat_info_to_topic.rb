class AddStatInfoToTopic < ActiveRecord::Migration
  def change
    add_column :topics,:first_handled_at,:timestamp
    add_column :topics,:completed_at,:timestamp
    add_column :topics,:last_handled_at,:timestamp
    add_column :topics,:last_redone_at,:timestamp
    add_column :topics,:state,:string,default: :new

  end
end
