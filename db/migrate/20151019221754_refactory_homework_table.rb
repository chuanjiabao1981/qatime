class RefactoryHomeworkTable < ActiveRecord::Migration
  def change
    add_column :examinations, :type, :string
  end
end
