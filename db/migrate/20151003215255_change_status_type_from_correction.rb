class ChangeStatusTypeFromCorrection < ActiveRecord::Migration
  def change
    change_column :corrections, :status, :string
  end
end