class AddStateToLesson < ActiveRecord::Migration
  def change
    add_column :lessons,:state,:string, :default => "init"
  end
end
