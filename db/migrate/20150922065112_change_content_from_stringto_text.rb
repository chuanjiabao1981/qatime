class ChangeContentFromStringtoText < ActiveRecord::Migration
  def change
    change_column :exercises,:content,:text
  end
end
