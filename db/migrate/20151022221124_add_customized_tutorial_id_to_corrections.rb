class AddCustomizedTutorialIdToCorrections < ActiveRecord::Migration
  def change
    add_column :corrections,:customized_tutorial_id,:integer

  end
end
