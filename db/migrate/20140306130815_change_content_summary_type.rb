class ChangeContentSummaryType < ActiveRecord::Migration
  def change
    change_column :tutorials,:summary,:text
    change_column :tutorials,:content,:text
  end
end
