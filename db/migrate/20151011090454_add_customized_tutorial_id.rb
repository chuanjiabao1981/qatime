class AddCustomizedTutorialId < ActiveRecord::Migration
  def change
    add_column :replies,:customized_tutorial_id,:integer
  end
end
