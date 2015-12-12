class AddCustomizedTutorialIdToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions,:customized_tutorial_id,:integer
  end
end
