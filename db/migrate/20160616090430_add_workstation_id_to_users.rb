class AddWorkstationIdToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :workstation, index: true
  end
end
