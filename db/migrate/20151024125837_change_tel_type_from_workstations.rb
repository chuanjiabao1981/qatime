class ChangeTelTypeFromWorkstations < ActiveRecord::Migration
  def change
    change_column :workstations, :tel, :string
  end
end
