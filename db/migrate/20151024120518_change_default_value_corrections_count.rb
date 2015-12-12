class ChangeDefaultValueCorrectionsCount < ActiveRecord::Migration
  def change
    change_column :solutions,:corrections_count,:integer,default: 0
  end
end
